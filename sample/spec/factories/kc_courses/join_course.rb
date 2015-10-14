FactoryGirl.define do
  factory :join_course, class: KcCourses::JoinCourse do
    user
    course
  end
end


