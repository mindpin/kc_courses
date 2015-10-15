FactoryGirl.define do
  factory :course_join, class: KcCourses::CourseJoin do
    user
    course
  end
end
