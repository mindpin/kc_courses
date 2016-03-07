FactoryGirl.define do
  factory :teaching_group, class: KcCourses::TeachingGroup do
    sequence(:name){|n| "小组#{n}"}
    sequence(:desc){|n| "小组#{n} 描述"}
    managers{[create(:user)]}
  end
end

