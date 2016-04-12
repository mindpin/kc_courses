module KcCourses
  module Concerns
    module Authorizeable
      extend ActiveSupport::Concern

      included do
        has_many :authorizes, as: :authorizeable, class_name: "KcCourses::Authorize"
      end

      def authorized_with?(user, val)
        authorizes.where(user: user, value: val).any?
      end

      def authorized?(user)
        authorizes.where(user: user).any?
      end

      def get_authorize(user)
        authorizes.where(user: user).first
      end

      def authorize_users
        User.where(:id.in => authorizes.map(&:user_id))
      end

      def authorize_users_with(val)
        User.where(:id.in => authorizes.where(value: val).map(&:user_id))
      end

      def set_authorize(user, val)
        if authorize = get_authorize(user)
          authorize.value = val
          authorize.save
        else
          authorizes.create(user: user, value: val)
        end
      end
    end
  end
end
