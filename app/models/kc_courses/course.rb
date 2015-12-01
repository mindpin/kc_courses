module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Publish
    include KcCourses::Concerns::CourseReadingMethods

    scope :studing_of_user, ->(user) {
      if user == nil
        course_ids = nil
      else
        course_ids = user.ware_readings.where(:read_percent.ne => 100).group_by(&:course_id).keys
      end
      where(:_id.in => course_ids)
    }

    scope :studied_of_user, ->(user) {
      if user == nil
        course_ids = nil 
      else
        course_ids = user.ware_readings.where(:read_percent => 100).group_by(&:course_id).keys
      end
      where(:_id.in => course_ids)
    }


    field :title, :type => String
    field :desc, :type => String
    field :cover, :type => String
    belongs_to :user

    has_many :chapters, class_name: 'KcCourses::Chapter'

    validates :title, presence: true
    validates :user, presence: true
  end
end
