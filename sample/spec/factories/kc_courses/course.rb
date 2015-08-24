FactoryGirl.define do
  factory :course, class: KcCourses::Course do
    title "课程1"
    desc "课程1 描述"
    user
  end
end
