module KcCourses
  module Concerns
    module CourseAuthorizeMethods
      extend ActiveSupport::Concern

      included do
        # 获取所有授权关系（关联 user_course_authorizes 表）
        # 除默认可观看的，其余被授权可以观看的 user_course_authorizes
        has_and_belongs_to_many :user_course_authorizes, inverse_of: :courses, class_name: 'KcCourses::UserCourseAuthorize'
      end

      # 判断用户是否被授权
      def user_course_authorized?(user)
        user_course_authorizes.where(user: user).any?
      end

      # 添加授权者
      # 在授权者列表中，则返回 nil
      # 不在授权者列表中，则返回 授权列表
      def add_user_course_authorize(user)
        user.create_user_course_authorize unless user.user_course_authorize
        unless user_course_authorized?(user)
          user.user_course_authorize.courses << self unless user.create_user_course_authorize.courses.include?(self)
        end
      end

      # 批量添加授权者 (users 为 user 数组)
      # 遍历添加
      def add_user_course_authorizes(users)
        users.each do |user|
          add_user_course_authorize(user)
        end
        true
      end

      # 移除授权者
      # 不在授权者列表中，则返回 nil
      # 在授权者列表中，则返回 user.user_course_authorize
      def remove_user_course_authorize(user)
        return nil unless user_course_authorized?(user)
        user_course_authorizes.delete(user.user_course_authorize)
      end

      # 批量移除授权者 (users 为 user 数组)
      # 遍历移除
      def remove_user_course_authorizes(users)
        users.each do |user|
          remove_user_course_authorize(user)
        end
        true
      end

      def authorized_users
        ids = user_course_authorizes.map(&:user_id).map(&:to_s)
        User.where(:id.in => ids)
      end

      module ClassMethods
      end
    end
  end
end

