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
      end
    end

  end
end
