module KcCourses
  class TeachingActivityMember
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::Base

    belongs_to :user, class_name: 'User', inverse_of: :activity_members
    belongs_to :activity, class_name: 'KcCourses::TeachingActivity', inverse_of: :activity_members

  end
end

