module KcCourses
  module Concerns
    module SubjectMethods
      extend ActiveSupport::Concern

      def has_subject?(subject)
        course_subjects.include? subject
      end

      def add_subject(subject)
        if !has_subject?(subject)
          course_subjects << subject
          subject.courses << self
        end
      end

      def remove_subject(subject)
        if has_subject?(subject)
          course_subjects.delete(subject)
          subject.courses.delete self
        end
      end

      module ClassMethods
      end
    end
  end
end
