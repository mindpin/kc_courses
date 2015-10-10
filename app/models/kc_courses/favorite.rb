module KcCourses
  class Favorite
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :user
    belongs_to :course, class_name: 'KcCourses::Course'
    validates :user, presence: true
    validates :course, presence: true
  end
end
