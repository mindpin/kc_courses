module KcCourses
  class Ware
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::MovePosition
    include KcCourses::Concerns::WareReadingMethod

    field :title, :type => String
    field :desc, :type => String

    belongs_to :chapter, class_name: 'KcCourses::Chapter'
    belongs_to :user
    has_many :ware_readings, class_name: 'KcCourses::WareReading'
    has_many :ware_reading_deltas, class_name: 'KcCourses::WareReadingDelta'
    
    validates :chapter,  :presence => true
    validates :user, presence: true

    # 重写MovePosition
    def parent
      chapter
    end
  end
end

