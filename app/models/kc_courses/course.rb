module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base
    include KcCourses::Concerns::Publish
    include KcCourses::Concerns::CourseReadingMethods
    include KcCourses::Concerns::SubjectMethods
    include KcCourses::Concerns::CourseStatisticInfo

    scope :studing_of_user, ->(user) {
      if user == nil
        course_ids = []
      else
        course_ids = KcCourses::Course.all.select do |course|
          if course.read_percent_of_user(user) != 100 && course.ware_readings.count != 0
            course.id
          end
        end
      end
      where(:_id.in => course_ids)
    }

    scope :studied_of_user, ->(user) {
      if user == nil
        course_ids = [] 
      else
        course_ids = KcCourses::Course.all.select do |course|
          if course.read_percent_of_user(user) == 100 
            course.id
          end
        end
      end
      where(:_id.in => course_ids)
    }



    field :title, :type => String
    field :desc, :type => String
    field :cover, :type => String

    belongs_to :user
    belongs_to :file_entity, class_name: 'FilePartUpload::FileEntity'

    has_many :chapters, class_name: 'KcCourses::Chapter'
    has_and_belongs_to_many :course_subjects, class_name: 'KcCourses::CourseSubject', inverse_of: :courses

    validates :title, presence: true
    validates :user, presence: true

    def get_cover(version=nil)
      (file_entity and file_entity.url(version)) || ENV['course_default_cover_url']
    end

    def get_publish_data
      good_as_json(
        include: {chapters: {
          include: {wares: {
            #include: [:file_entity]
          }}
        }}
      )
    end
  end
end
