module KcCourses
  class TeachingActivity
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    field :name, type: String
    field :desc, type: String

    belongs_to :creator, class_name: 'User'#, inverse_of: 

    has_many :events, class_name: 'KcCourses::TeachingEvent', inverse_of: :activity
    has_many :lessons, class_name: 'KcCourses::TeachingLesson', inverse_of: :activity

    # 负责人中间表
    has_many :activity_managers, class_name: 'KcCourses::TeachingActivityManager', inverse_of: :activity

    # 参与者中间表
    has_many :activity_users, class_name: 'KcCourses::TeachingActivityUser', inverse_of: :activity

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
    def users
      User.where(:id.in => activity_users.map(&:user_id))
    end

    def has_user? user
      activity_users.where(user_id: user.id).any?
    end

    def add_user user
      activity_users.create(user: user) unless has_user?(user)
    end

  end
end
