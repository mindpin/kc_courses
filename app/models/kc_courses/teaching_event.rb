module KcCourses
  class TeachingEvent
    include Mongoid::Document
    include Mongoid::Timestamps
    # 时间范围模块
    include KcCourses::Concerns::TimeRange

    field :desc, type: String

    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :events
    belongs_to :course, class_name: 'KcCourses::Course'#, inverse_of: :events
  end
end

