FactoryGirl.define do
  factory :authorize, class: KcCourses::Authorize do
    sequence(:value){|n| "value#{n}"}
    user
    authorizeable {create(:teaching_group)}
  end
end

