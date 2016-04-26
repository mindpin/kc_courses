module KcCourses
  module Concerns
    module UserActivityMethods
      extend ActiveSupport::Concern

      included do
        has_many :activity_managers, class_name: 'KcCourses::TeachingActivityManager', inverse_of: :user
        has_many :activity_users, class_name: 'KcCourses::TeachingActivityUser', inverse_of: :user
      end

      def joined_activities
        KcCourses::TeachingActivity.where(:id.in => activity_users.map(&:activity_id))
      end

      def manage_activities
        KcCourses::TeachingActivity.where(:id.in => activity_managers.map(&:activity_id))
      end
    end
  end
end
