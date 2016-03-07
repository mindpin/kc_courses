module KcCourses
  module Concerns
    module Authorize
      extend ActiveSupport::Concern

      included do
        # 获取所有授权者（关联 user 表）
        # 除默认可观看的，其余被授权可以观看的 users
        has_and_belongs_to_many :authorized_members, inverse_of: :authorized_teaching_groups, class_name: 'User'
      end

      # 判断用户是否被授权
      def authorized?(user)
        authorized_members.include?(user)
      end

      # 添加授权者
      # 在授权者列表中，则返回 nil
      # 不在授权者列表中，则返回 user
      def add_authorized_member(user)
        authorized_members << user unless authorized?(user)
      end

      # 批量添加授权者 (users 为 user 数组)
      # 遍历添加
      def add_authorized_members(users)
        users.each do |user|
          add_authorized_member(user)
        end
        true
      end

      # 移除授权者
      # 不在授权者列表中，则返回 nil
      # 在授权者列表中，则返回 user
      def remove_authorized_member(user)
        authorized_members.delete(user) if authorized?(user)
      end

      # 批量移除授权者 (users 为 user 数组)
      # 遍历移除
      def remove_authorized_members(users)
        users.each do |user|
          remove_authorized_member(user)
        end
        true
      end

      def all_manager_ids
        ancestors_and_self.map(&:manager_ids).flatten.uniq
      end

      # 获取所有管理者
      # 即自身管理者，以及所有祖先级的管理者
      # scope，不重复
      def all_managers
        User.where(:id.in => all_manager_ids)
      end

      def all_viewer_ids
        (all_manager_ids + member_ids + authorized_member_ids).uniq
      end

      # 获取可观看人员
      # 所有管理者+组员+授权人员
      # scope，不重复
      def all_viewers
        User.where(:id.in => all_viewer_ids)
      end

      # 是否可管理
      # 判断用户是否在所有管理员当中
      def could_manage?(user)
        all_manager_ids.include?(user.id)
      end

      # 是否可观看
      # 判断用户是否在所有可观看者当中
      def could_view?(user)
        all_viewer_ids.include?(user.id)
      end

      module ClassMethods
      end
    end
  end
end
