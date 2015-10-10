FactoryGirl.define do
  factory :join, class: KcCourses::Join do
    user
    course
  end
end


