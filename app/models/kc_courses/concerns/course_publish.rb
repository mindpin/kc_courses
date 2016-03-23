module KcCourses
  module Concerns
    module CoursePublish
      extend ActiveSupport::Concern

      included do
        has_one :published_course, class_name: 'KcCourses::PublishedCourse'
        has_many :published_course_snapshots, class_name: 'KcCourses::PublishedCourseSnapshot'
      end

      def get_publish_data
        good_as_json(
          include: {chapters: {
            include: {wares: {
              methods: [:_type]
              #include: [:cover_file_entity]
            }}
          }}
        )
      end

      def publish!
        if unpublish!
          published_course.update_attributes enabled: true, data: get_publish_data
          published_course.save_snapshot
        else
          create_published_course enabled: true, data: get_publish_data
          published_course.save_snapshot
        end
        true
      end

      def unpublish!
        published_course.update_attribute :enabled, false unless published_course.nil?
      end

      module ClassMethods
      end
    end
  end
end
