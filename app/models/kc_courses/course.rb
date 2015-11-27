module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Publish
    include KcCourses::Concerns::CourseReadingMethods

    scope :hot, -> {recent}
    def self.studing_of_user(user)
      KcCourses::Course.all.select do |course|
        if course.read_percent_of_user(user) != 100 && course.read_percent_of_user(user) != 0
          where(:id => course.id.to_s)
        end
      end
    end

    def self.studied_of_user(user)
      KcCourses::Course.all.select do |course|
        if course.read_percent_of_user(user) == 100
          where(:id => course.id.to_s)
        end
      end
    end

    field :title, :type => String
    field :desc, :type => String
    field :cover, :type => String
    belongs_to :user

    has_many :chapters, class_name: 'KcCourses::Chapter'

    validates :title, presence: true
    validates :user, presence: true
  end
end
