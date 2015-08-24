module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Publish

    field :title, :type => String
    field :desc, :type => String
    belongs_to :user

    has_many :chapters, class_name: 'KcCourses::Chapter'

    validates :title, presence: true
    validates :user, presence: true
  end
end
