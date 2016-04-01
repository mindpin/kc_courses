require 'ruby-pinyin'

module KcCourses
  class CourseSubject
    include Mongoid::Document
    include Mongoid::Timestamps
    # 树状支持
    # https://github.com/benedikt/mongoid-tree
    include Mongoid::Tree

    field :name, :type => String
    field :slug, :type => String

    has_and_belongs_to_many :courses, class_name: 'KcCourses::Course', inverse_of: nil

    validates :name, presence: true

    before_save :build_slug
    def build_slug
      self.slug = PinYin.permlink(name)
    end
  end
end
