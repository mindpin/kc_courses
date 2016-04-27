module KcCourses
  class TeachingActivityManager
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    belongs_to :user, class_name: 'User', inverse_of: :activity_managers
    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :activity_managers

  end
end
