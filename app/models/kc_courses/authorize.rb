module KcCourses
  class Authorize
    include Mongoid::Document
    include Mongoid::Timestamps

    field :value, type: String

    belongs_to :authorizeable, polymorphic: true
    belongs_to :user

    validates :value, presence: true
  end
end

