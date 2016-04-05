module KcCourses
  class UserCourseAuthorize
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user, inverse_of: :user_course_authorize

    has_and_belongs_to_many :courses, class_name: 'KcCourses::Course', inverse_of: :user_course_authorizes
  end
end
