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

    validates :chapter,  :presence => true
    validates :user, presence: true

    # 重写MovePosition
    def parent
      chapter
    end
  end
end
