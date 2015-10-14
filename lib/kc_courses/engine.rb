module KcCourses
  class Engine < ::Rails::Engine
    isolate_namespace KcCourses
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper

      User.class_eval do
        has_many :courses, class_name: 'KcCourses::Course'
        has_many :chapters, class_name: 'KcCourses::Chapter'
        has_many :wares, class_name: 'KcCourses::Ware'
        has_many :join_courses, class_name: 'KcCourses::JoinCourse'

        define_method :join_course do |course|
          return if course.class.name != 'KcCourses::Course'
          unless self.join_courses.where(course: course).any?
            self.join_courses.create course: course
          end
        end

        define_method :cancel_join_course do |course|
          join_courses.where(course: course).destroy_all > 0 ? true : false
        end
      end
    end

  end
end
