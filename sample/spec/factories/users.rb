FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "user#{n}"}
    sequence(:email){|n| "user#{n}@example.com"}
    password "123456"
  end

  factory :user_course_creator, class: User do
    sequence(:name){|n| "user_course_creator#{n}"}
    sequence(:email){|n| "user_course_creator#{n}@example.com"}
    password "123456"
  end
end
