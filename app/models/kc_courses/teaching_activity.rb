module KcCourses
  class TeachingActivity
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    field :name, type: String
    field :desc, type: String

    belongs_to :manager, class_name: 'User'#, inverse_of: 

    has_many :events, class_name: 'KcCourses::TeachingEvent', inverse_of: :activity
    has_many :lessons, class_name: 'KcCourses::TeachingLesson', inverse_of: :activity

    validates :name, presence: true
  end
end
