module KcCourses
  class TeachingActivityUser
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    belongs_to :user, class_name: 'User', inverse_of: :activity_users
    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :activity_users

  end
end

