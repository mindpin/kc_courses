module KcCourses
  module Concerns
    module DiscussAuthorize
      extend ActiveSupport::Concern

      included do
        # 授权
        include KcCourses::Concerns::Authorizeable
        # 讨论组权限设定
        include KcCourses::Concerns::DiscussSetting

        # 讨论权限
        DISCUSS_AUTHORIZE_KINDS = %w[teaching_group_ban teaching_group_view teaching_group_full]
      end

      # 判断用户是否可浏览
      def could_view_by?(user)
        (
          # 是成员
          has_member?(user) or
          # 设置可读
          all_could_view or
          # 授权可读
          authorized_with?(user, 'teaching_group_view') or
          # 完全授权
          authorized_with?(user, 'teaching_group_full')
        ) and
        # 未被屏蔽
        !authorized_with?(user, 'teaching_group_ban')
      end

      # 判断用户是否可发帖
      def could_post_by?(user)
        (
          # 是成员
          has_member?(user) or
          # 设置可读
          all_could_post or
          # 完全授权
          authorized_with?(user, 'teaching_group_full')
        ) and
        # 未被屏蔽
        !authorized_with?(user, 'teaching_group_ban') and
        !authorized_with?(user, 'teaching_group_view')
      end

      # 添加屏蔽用户
      # 如果用户已被设置其他特殊权限，会被刷新
      # 始终返回 true
      def add_ban_member(user)
        set_authorize(user, "teaching_group_ban")
      end

      # 添加仅可读用户
      # 如果用户已被设置其他特殊权限，会被刷新
      # 始终返回 true
      def add_view_member(user)
        set_authorize(user, "teaching_group_view")
      end

      # 添加完全开放用户
      # 如果用户已被设置其他特殊权限，会被刷新
      # 始终返回 true
      def add_full_member(user)
        set_authorize(user, "teaching_group_full")
      end

      # 批量添加授权者 (users 为 user 数组)
      # 遍历添加
      #def add_authorized_members(users)
        #users.each do |user|
          #add_authorized_member(user)
        #end
        #true
      #end

      # 移除授权者
      # 不在授权者列表中，则返回 nil
      # 在授权者列表中，则返回 user
      #def remove_authorized_member(user)
        #authorized_members.delete(user) if authorized?(user)
      #end

      # 批量移除授权者 (users 为 user 数组)
      # 遍历移除
      #def remove_authorized_members(users)
        #users.each do |user|
          #remove_authorized_member(user)
        #end
        #true
      #end

      #def all_viewer_ids
        #(all_manager_ids + member_ids + authorized_member_ids).uniq
      #end

      # 获取可观看人员
      # 所有管理者+组员+授权人员
      # scope，不重复
      #def all_viewers
        #User.where(:id.in => all_viewer_ids)
      #end

      # 是否可观看
      # 判断用户是否在所有可观看者当中
      #def could_view?(user)
        #all_viewer_ids.include?(user.id)
      #end

      module ClassMethods
      end
    end
  end
end
