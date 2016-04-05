User.class_eval do
  has_one :user_course_authorize, class_name: 'KcCourses::UserCourseAuthorize', inverse_of: :user
end
