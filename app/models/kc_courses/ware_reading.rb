module KcCourses
  class WareReading
    include Mongoid::Document
    include Mongoid::Timestamps

    field :read_percent, :type => Integer

    belongs_to :creator, class_name: 'User'
    belongs_to :ware, class_name: 'KcCourses::Ware'

    after_save :process_ware_reading_delta
    def process_ware_reading_delta
      return true if self.ware.blank?
      delta = self.ware.ware_reading_deltas.where(:creator_id => self.creator_id.to_s, :time => Time.zone.now.beginning_of_day).first
      before_day_read_percent = self.ware.read_percent_of_user_before_day(self.creator, Time.zone.now - 1.day)
      if delta.blank?
        delta = self.ware.ware_reading_deltas.create(
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
