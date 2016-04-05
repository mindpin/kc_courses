module KcCourses
  module Concerns
    module UserAuthorizeMethods
      extend ActiveSupport::Concern
      included do
        has_one :user_course_authorize, class_name: 'KcCourses::UserCourseAuthorize', inverse_of: :user
      end

      def authorized_courses
        create_user_course_authorize unless user_course_authorize
        user_course_authorize.courses
      end

      module ClassMethods

      end
    end
  end
end
