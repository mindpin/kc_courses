module KcCourses
  class WareReading
    include Mongoid::Document
    include Mongoid::Timestamps

    field :read_percent, :type => Integer

    belongs_to :creator, class_name: 'User'
    belongs_to :course, class_name: 'KcCourses::Course'
    belongs_to :chapter, class_name: 'KcCourses::Chapter'
    belongs_to :ware, class_name: 'KcCourses::Ware'

  end
end
