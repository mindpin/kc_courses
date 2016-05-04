module KcCourses
  class TeachingLessonRecord
    include Mongoid::Document
    include Mongoid::Timestamps

    field :is_finished, type: Boolean, default: false
    belongs_to :lesson, class_name: 'KcCourses::TeachingLesson', inverse_of: :records
    belongs_to :user
    belongs_to :course, class_name: "KcCourses::Course"
  end
end
