module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base
    include KcCourses::Concerns::CoursePublish
    include KcCourses::Concerns::SubjectMethods
    include KcCourses::Concerns::CourseStatisticInfo
    include KcCourses::Concerns::CourseAuthorizeMethods

    field :name, :type => String
    field :desc, :type => String

    belongs_to :creator, class_name: 'User'
    belongs_to :cover_file_entity, class_name: 'FilePartUpload::FileEntity'

    has_many :chapters, class_name: 'KcCourses::Chapter'
    has_and_belongs_to_many :course_subjects, class_name: 'KcCourses::CourseSubject', inverse_of: nil

    validates :name, presence: true
    validates :creator, presence: true

    def cover(version=nil)
      (cover_file_entity and cover_file_entity.url(version)) || ENV['course_default_cover_url']
    end
  end
end
