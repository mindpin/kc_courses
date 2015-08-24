FactoryGirl.define do
  factory :ware, class: KcCourses::Ware do
    sequence(:title){|n| "课件#{n}"}
    sequence(:desc){|n| "课件#{n} 描述"}
    chapter
    user
  end
end


