FactoryGirl.define do
  factory :chapter, class: KcCourses::Chapter do
    title "章节1"
    desc "章节1 描述"
    course
  end
end

