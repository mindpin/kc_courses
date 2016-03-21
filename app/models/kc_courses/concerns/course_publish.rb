module KcCourses
  module Concerns
    module CoursePublish
      extend ActiveSupport::Concern

      included do
        has_many :published_courses
      end

      def publish!
        unpublish!

        published_courses.create enabled: true, data: get_publish_data
      end

      def unpublish!
        published_courses.enabled.update_all enabled: false if published_courses.enabled.any?
      end

      module ClassMethods
      end
    end
  end
end
