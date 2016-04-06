module KcCourses
  class TeachingActivity
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    field :name, type: String
    field :desc, type: String
    field :started_at, type: Time
    field :ended_at, type: Time

    belongs_to :manager, class_name: 'User'#, inverse_of: 

    validates :name, presence: true
  end
end
