module KcCourses
  class Ware
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::MovePosition

    field :title, :type => String
    field :desc, :type => String

    belongs_to :chapter, class_name: 'KcCourses::Chapter'

    # 重写MovePosition
    def parent
      chapter
    end
  end
end

