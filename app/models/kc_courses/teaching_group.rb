module KcCourses
  class TeachingGroup
    include Mongoid::Document
    include Mongoid::Timestamps
    # 树状支持
    # https://github.com/benedikt/mongoid-tree
    include Mongoid::Tree

    field :name, :type => String
    field :desc, :type => String
    # 图标
    # field :icon

    has_and_belongs_to_many :managers, class_name: 'User', inverse_of: :manage_teaching_groups
    has_and_belongs_to_many :members, class_name: 'User', inverse_of: :joined_teaching_groups

    has_many :activities, class_name: 'KcCourses::TeachingActivity', inverse_of: :group

    validates :name, presence: true
    validate  :require_at_least_one_manager

    def has_member?(user)
      members.include?(user)
    end

    def has_manager?(user)
      managers.include?(user)
    end

    def add_member(user)
      members << user unless has_member?(user)
    end

    def add_members(users)
      users.each do |user|
        add_member(user)
      end
      true
    end

    def remove_member(user)
      if has_member?(user)
        return false if has_manager?(user)
        members.delete(user)
      end
    end

    def remove_members(users)
      users.each do |user|
        remove_member(user)
      end
      true
    end

    def add_manager(user)
      unless has_manager?(user)
        members << user unless has_member?(user)
        managers << user
      end
    end

    def add_managers(users)
      users.each do |user|
        add_manager(user)
      end
      true
    end

    def remove_manager(user)
      if has_manager?(user)
        return false if managers.length == 1
        managers.delete(user)
      end
    end

    def remove_managers(users)
      users.each do |user|
        remove_manager(user)
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

    # 是否可管理
    # 判断用户是否在所有管理员当中
    def could_manage?(user)
      all_manager_ids.include?(user.id)
    end

    protected
    def require_at_least_one_manager
      errors.add(:managers, :at_least_one) if managers.blank?
    end
  end
end
