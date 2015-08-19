module KcCourses
  class Course
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, :type => String
    field :desc, :type => String

    has_many :chapters, class_name: 'KcCourses::Chapter'
  end
end
