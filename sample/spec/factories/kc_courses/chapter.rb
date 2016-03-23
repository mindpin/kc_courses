FactoryGirl.define do
  factory :chapter, class: KcCourses::Chapter do
    sequence(:title){|n| "章节#{n}"}
    sequence(:desc){|n| "章节#{n} 描述"}
    course
    creator {create(:user)}
  end
end
