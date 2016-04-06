FactoryGirl.define do
  factory :teaching_activity, class: KcCourses::TeachingActivity do
    sequence(:name){|n| "教学活动#{n}"}
    sequence(:desc){|n| "教学活动#{n} 描述"}
    manager {create(:user)}
  end

end
