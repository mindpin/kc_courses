module KcCourses
  module Concerns
    module SubjectMethods
      extend ActiveSupport::Concern

      def add_subject(subject)
        course_subjects << subject
      end

      def remove_subject(subject)
        course_subjects.delete subject
      end

      module ClassMethods
      end
    end
  end
end
