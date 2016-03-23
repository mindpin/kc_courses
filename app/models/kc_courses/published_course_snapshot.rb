module KcCourses
  class PublishedCourseSnapshot
    include Mongoid::Document
    include Mongoid::Timestamps

    #field :enabled, type: Boolean, default: false # 是否启用，取 true 或 false
    field :data # 把课程的结构数据整个怼进去
    belongs_to :course, class_name: 'KcCourses::Course' # 方便找到对应的原始数据
    belongs_to :published_course, class_name: 'KcCourses::PublishedCourse' # 方便找到对应的最新发布数据

    validates :course, presence: true
    validates :published_course, presence: true

    #scope :enabled, ->{where(enabled: true)}
  end
end
