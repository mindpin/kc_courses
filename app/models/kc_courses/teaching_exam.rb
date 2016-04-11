module KcCourses
  class TeachingExam
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base
    # 时间范围模块
    include KcCourses::Concerns::TimeRange

    field :name, type: String
    field :desc, type: String

    belongs_to :teaching_group, class_name: 'KcCourses::TeachingGroup'#, inverse_of: :activities
    validates :teaching_group, presence: true
    # 测评时间必填
    validates :started_at, presence: true
    validates :ended_at, presence: true

    def state
      return '未开始' if !started?
      return '已开考' if running?
      '已结束'
    end
  end
end
