module KcCourses
  module Concerns
    module SubjectMethods
      extend ActiveSupport::Concern

      def has_subject?(subject)
        course_subjects.include? subject
      end

      def add_subject(subject)
        course_subjects << subject unless has_subject?(subject)
      end

      def remove_subject(subject)
        course_subjects.delete(subject) if has_subject?(subject)
      end

      module ClassMethods
      end
    end
  end
end
