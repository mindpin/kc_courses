FactoryGirl.define do
  factory :teaching_exam, class: KcCourses::TeachingExam do
    sequence(:name){|n| "课件#{n}"}
    sequence(:desc){|n| "课件#{n} 描述"}
    started_at {1.day.ago}
    ended_at {1.day.from_now}
    teaching_group
  end
end
