module KcCourses
  class TeachingActivity
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base
    # 讨论组权限
    include KcCourses::Concerns::DiscussAuthorize

    field :name, type: String
    field :desc, type: String
    field :learn_week, type: Integer, default: 0

    belongs_to :creator, class_name: 'User'#, inverse_of: 

    has_many :events, class_name: 'KcCourses::TeachingEvent', inverse_of: :activity
    has_many :lessons, class_name: 'KcCourses::TeachingLesson', inverse_of: :activity

    # 负责人中间表
    has_many :activity_managers, class_name: 'KcCourses::TeachingActivityManager', inverse_of: :activity

    # 参与者中间表
    has_many :activity_members, class_name: 'KcCourses::TeachingActivityMember', inverse_of: :activity

    validates :name, presence: true

    # 负责人scope
    def managers
      User.where(:id.in => activity_managers.map(&:user_id))
    end

    def has_manager? user
      activity_managers.where(user_id: user.id).any?
    end

    def add_manager user
      activity_managers.create(user: user) unless has_manager?(user)
    end

    # 参与者scope
    def members
      User.where(:id.in => activity_members.map(&:user_id))
    end

    def has_member? user
      activity_members.where(user_id: user.id).any?
    end

    def add_member user
      activity_members.create(user: user) unless has_member?(user)
    end

  end
end
