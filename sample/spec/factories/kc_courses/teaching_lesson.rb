FactoryGirl.define do
  factory :teaching_lesson, class: KcCourses::TeachingLesson do
    manager {create(:user)}
  end

end

