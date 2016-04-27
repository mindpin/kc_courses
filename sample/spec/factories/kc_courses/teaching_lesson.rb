FactoryGirl.define do
  factory :teaching_lesson, class: KcCourses::TeachingLesson do
    creator {create(:user)}
  end

end

