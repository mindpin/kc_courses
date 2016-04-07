module KcCourses
  class TeachingEvent
    include Mongoid::Document
    include Mongoid::Timestamps

    field :desc, type: String
    field :started_at, type: Time
    field :ended_at, type: Time

    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :events
    belongs_to :course, class_name: 'KcCourses::Course'#, inverse_of: :events
  end
end

