module KcCourses
  class WareReading
    include Mongoid::Document
    include Mongoid::Timestamps

    field :read_percent, :type => Integer

    belongs_to :creator, class_name: 'User'
    belongs_to :course, class_name: 'KcCourses::Course'
    belongs_to :chapter, class_name: 'KcCourses::Chapter'
    belongs_to :ware, class_name: 'KcCourses::Ware'


    before_create :set_chapter_id_and_course_id
    def set_chapter_id_and_course_id
      if !self.ware.blank?
        self.chapter = self.ware.chapter
      end

      if !self.chapter.blank?
        self.course = self.chapter.course
      end

      return true
    end

    after_save :process_ware_reading_delta
    def process_ware_reading_delta
      return true if self.ware.blank?
      delta = self.ware.ware_reading_deltas.where(:creator_id => self.creator_id.to_s, :time => Time.zone.now.beginning_of_day).first
      before_day_read_percent = self.ware.read_percent_of_user_before_day(self.creator, Time.zone.now - 1.day)
      if delta.blank?
        delta = self.ware.ware_reading_deltas.create(
          :chapter    => self.chapter,
          :course     => self.course,
          :creator_id => self.creator_id.to_s,
          :time => Time.zone.now.beginning_of_day,
          :read_percent_change => self.read_percent - before_day_read_percent,
          :read_percent        => self.read_percent
        )
      else
        delta.update(
          :read_percent_change => self.read_percent - before_day_read_percent,
          :read_percent        => self.read_percent
        )
      end
    end

  end
end
