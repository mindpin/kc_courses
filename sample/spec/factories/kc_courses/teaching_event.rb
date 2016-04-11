FactoryGirl.define do
  factory :teaching_event, class: KcCourses::TeachingEvent do
    sequence(:desc){|n| "教学事件#{n} 描述"}
  end
end

