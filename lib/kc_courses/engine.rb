module KcCourses
  class Engine < ::Rails::Engine
    isolate_namespace KcCourses
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper

      Dir.glob(Rails.root + "app/decorators/kc_courses/**/*_decorator.rb").each do |c|
        require_dependency(c)
      end

      User.class_eval do
        has_many :courses, class_name: 'KcCourses::Course'
        has_many :chapters, class_name: 'KcCourses::Chapter'
        has_many :wares, class_name: 'KcCourses::Ware'
        has_many :course_joins, class_name: 'KcCourses::CourseJoin'
        has_many :ware_readings, class_name: 'KcCourses::WareReading'
        has_many :ware_reading_deltas, class_name: 'KcCourses::WareReadingDelta'

        define_method :join_course do |course|
          return if course.class.name != 'KcCourses::Course'
          unless self.course_joins.where(course: course).any?
            self.course_joins.create course: course
          end
        end

        define_method :cancel_join_course do |course|
          course_joins.where(course: course).destroy_all > 0 ? true : false
        end

        define_method :join_courses do |&block|
          if block.blank?
            joins = self.course_joins
          else
            joins = block.call self.course_joins
          end
          join_ids = joins.map{|join|join.course_id.to_s}
          KcCourses::Course.where(:id.in => join_ids)
        end
      end
    end
  end
end
