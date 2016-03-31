FactoryGirl.define do
  factory :course, class: KcCourses::Course do
    name "课程1"
    desc "课程1 描述"
    creator {create(:user)}
  end

end
