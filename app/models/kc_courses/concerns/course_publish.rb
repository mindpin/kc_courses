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

      # 发布
      # 同个内容重复发布,则保存多次同样的快照
      # 始终返回 true
      def publish!
        # 是否已发布过
        if published_course
          published_course.update_attributes enabled: true, data: get_publish_data
        else
          create_published_course enabled: true, data: get_publish_data
        end
        published_course.save_snapshot
        true
      end

      # 取消发布
      # 未曾发布过的，返回 nil
      # 曾发布过的，则返回 true
      def unpublish!
        published_course.update_attribute :enabled, false if published_course
      end

      module ClassMethods
      end
    end
  end
end
