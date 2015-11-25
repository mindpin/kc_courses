module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Publish
    include KcCourses::Concerns::WareReadingMethod
    
    def self.studing_of_user(user)
      arr = []
      KcCourses::WareReading.where(:"creator_id" => user.id.to_s).distinct("course_id").select do |course_id|
        if self.find(course_id).ware_readings.last.read_percent != 100
          course_id
        end
      end.map do |id|
        arr << self.find(id)
      end.compact
      return arr
    end

    def self.studied_of_user(user)
      arr = []
      KcCourses::WareReading.where(:"creator_id" => user.id.to_s).distinct("course_id").select do |course_id|
        if self.find(course_id).ware_readings.last.read_percent == 100
          course_id
        end
      end.map do |id|
        arr << self.find(id)
      end.compact
      return arr
    end

    field :title, :type => String
    field :desc, :type => String
    field :cover, :type => String
    belongs_to :user

    has_many :chapters, class_name: 'KcCourses::Chapter'
    has_many :ware_readings, class_name: 'KcCourses::WareReading'
    has_many :ware_reading_deltas, class_name: 'KcCourses::WareReadingDelta'

    validates :title, presence: true
    validates :user, presence: true
  end
end
