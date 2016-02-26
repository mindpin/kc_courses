FactoryGirl.define do
  factory :course_subject, class: KcCourses::CourseSubject do
    name "课程1"
    courses{[create(:course)]}
  end
end
