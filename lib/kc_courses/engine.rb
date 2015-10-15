module KcCourses
  class Engine < ::Rails::Engine
    isolate_namespace KcCourses
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper

      User.class_eval do
        has_many :courses, class_name: 'KcCourses::Course'
        has_many :chapters, class_name: 'KcCourses::Chapter'
        has_many :wares, class_name: 'KcCourses::Ware'
        has_many :course_joins, class_name: 'KcCourses::CourseJoin'

        define_method :join_course do |course|
          return if course.class.name != 'KcCourses::Course'
          unless self.course_joins.where(course: course).any?
            self.course_joins.create course: course
          end
        end

        define_method :cancel_join_course do |course|
          course_joins.where(course: course).destroy_all > 0 ? true : false
        end
      end
    end

  end
end
