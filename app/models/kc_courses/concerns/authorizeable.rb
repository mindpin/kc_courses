module KcCourses
  module Concerns
    module Authorizeable
      extend ActiveSupport::Concern

      included do
        has_many :authorizes, as: :authorizeable, class_name: "KcCourses::Authorize"
      end

      def authorized_with?(user, val)
        case val.class.name
        when "String"
          authorizes.where(user: user, value: val).any?
        when "Array"
          authorizes.where(user: user, :value.in => val).any?
        else
          false
        end
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

      def authorize_user_ids_with(val)
        authorizes.where(value: val).map(&:user_id)
      end

      def authorize_users_with(val)
        User.where(:id.in => authorize_user_ids_with(val))
      end

      def set_authorize(user, val)
        if authorize = get_authorize(user)
          authorize.value = val
          authorize.save
        else
          authorize = authorizes.create(user: user, value: val)
          authorize.valid?
        end
      end
    end
  end
end
