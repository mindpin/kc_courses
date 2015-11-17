module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Publish
    include KcCourses::Concerns::WareReadingMethod
    
    def self.studing_of_user(user)
      arr = []
      self.where(:user_id => user.id.to_s).map do |course|
        if course.has_read_by_user?(user) == false
          arr[arr.length] = course
        end
      end
      return arr.compact  
    end

    def self.studied_of_user(user)
      arr = []
      self.where(:user_id => user.id.to_s).map do |course|
        if course.has_read_by_user?(user) == true
          arr[arr.length] = course
        end
      end
      return arr.compact  
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
