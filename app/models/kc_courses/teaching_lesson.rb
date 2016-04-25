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
    belongs_to :manager, class_name: 'User'#, inverse_of: 
    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :lessons

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
  end
end
