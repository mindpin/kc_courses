FactoryGirl.define do
  factory :published_course_snapshot, class: KcCourses::PublishedCourseSnapshot do
    course
    published_course
  end
end
