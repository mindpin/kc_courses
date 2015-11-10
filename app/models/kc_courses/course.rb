module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Publish

    field :title, :type => String
    field :desc, :type => String
    field :cover, :type => String
    belongs_to :user

    has_many :chapters, class_name: 'KcCourses::Chapter'
    has_many :ware_readings, class_name: 'KcCourses::WareReading'
    has_many :ware_reading_deltas, class_name: 'KcCourses::WareReadingDelta'

    validates :title, presence: true
    validates :user, presence: true
  end
end
