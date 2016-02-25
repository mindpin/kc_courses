module KcCourses
  class CourseSubject
    include Mongoid::Document
    include Mongoid::Timestamps

    field :name, :type => String
    field :show_in_nav, :type => Boolean, default: false
    field :show_in_subnav, :type => Boolean, default: false

    has_and_belongs_to_many :courses, class_name: 'KcCourses::Course', inverse_of: :course_subjects

    validates :name, presence: true
    validate :validate_number_of_courses

    protected
    def validate_number_of_courses
      errors.add(:courses, "课程不能为空") if courses.count == 0
    end
  end
end
