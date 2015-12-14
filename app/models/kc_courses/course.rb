module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base
    include KcCourses::Concerns::Publish
    include KcCourses::Concerns::CourseReadingMethods

    scope :studing_of_user, ->(user) {
      if user == nil
        course_ids = []
      else
        course_ids = KcCourses::Course.all.select do |course|
          if course.read_percent_of_user(user) != 100 && course.ware_readings.count != 0
            course.id
          end
        end
      end
      where(:_id.in => course_ids)
    }

    scope :studied_of_user, ->(user) {
      if user == nil
        course_ids = [] 
      else
        course_ids = KcCourses::Course.all.select do |course|
          if course.read_percent_of_user(user) == 100 
            course.id
          end
        end
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
