FactoryGirl.define do
  factory :ware, class: KcCourses::Ware do
    sequence(:name){|n| "课件#{n}"}
    sequence(:desc){|n| "课件#{n} 描述"}
    chapter
    creator {create(:user)}
  end
end
