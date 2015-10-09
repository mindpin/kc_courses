FactoryGirl.define do
  factory :favorite, class: KcCourses::Favorite do
    user
    course
  end
end

