module KcCourses
  class TeachingActivity
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    field :name, type: String
    field :desc, type: String
    field :started_at, type: Time
    field :ended_at, type: Time
    # 报名
    field :apply_started_at, type: Time
    field :apply_ended_at, type: Time

    belongs_to :manager, class_name: 'User'#, inverse_of: 

    belongs_to :group, class_name: 'KcCourses::TeachingGroup', inverse_of: :activities

    has_many :events, class_name: 'KcCourses::TeachingEvent', inverse_of: :activity

    validates :name, presence: true

    def started?
      started_at.nil? || Time.now >= started_at
    end

    def ended?
      return false if ended_at.nil?
      Time.now >= ended_at
    end

    def running?
      started? and !ended?
    end

    def apply_started?
      apply_started_at.nil? || Time.now >= apply_started_at
    end

    def apply_ended?
      return false if apply_ended_at.nil?
      Time.now >= apply_ended_at
    end

    def could_apply?
      apply_started? and !apply_ended?
    end
  end
end
