module KcCourses
  class TeachingLesson
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base
    # 时间范围模块
    include KcCourses::Concerns::TimeRange

    # 报名
    field :apply_started_at, type: Time
    field :apply_ended_at, type: Time

    belongs_to :group, class_name: 'KcCourses::TeachingGroup', inverse_of: :activities
    belongs_to :creator, class_name: 'User'#, inverse_of: 
    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :lessons

    has_many :records, class_name: 'KcCourses::TeachingLessonRecord', inverse_of: :lesson
    has_many :exams, class_name: 'KcCourses::TeachingExam', inverse_of: :lesson

    def apply_started?
      apply_started_at.nil? || Time.now >= apply_started_at
    end

    def apply_ended?
      return false if apply_ended_at.nil?
      Time.now >= apply_ended_at
    end

    def could_apply?
      apply_started? and !apply_ended?
    end

    def finished_with_course_by_user? course, user
      records.where(course: course, user: user).first.try(:is_finished) || false
    end

    def finish_with_course_by_user! course, user
      unless finished_with_course_by_user?(course, user)
        record = records.where(course: course, user: user).first
        if record
          record.update_attribute :is_finished, true unless record.is_finished
          return true
        end
        records.create(course: course, user: user, is_finished: true)
      end
    end
  end
end
