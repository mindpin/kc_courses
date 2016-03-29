module KcCourses
  class Ware
    include Mongoid::Document
    include Mongoid::Timestamps
    include KcCourses::Concerns::MovePosition
    include KcCourses::Concerns::WareReadingMethod

    field :name, :type => String
    field :desc, :type => String

    belongs_to :chapter, class_name: 'KcCourses::Chapter'
    belongs_to :creator, class_name: 'User'

    belongs_to :file_entity, class_name: 'FilePartUpload::FileEntity'

    validates :chapter,  :presence => true
    validates :creator, presence: true

    # 重写MovePosition
    def parent
      chapter
    end
  end
end
