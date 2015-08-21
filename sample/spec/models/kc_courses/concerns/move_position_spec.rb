require 'rails_helper'

class MovePositionTestParent
  include Mongoid::Document
  has_many :tests, class_name: 'MovePositionTest'
end

class MovePositionTest
  include Mongoid::Document
  include KcCourses::Concerns::MovePosition
  belongs_to :father, class_name: 'MovePositionTestParent'

  def parent
    father
  end
end

RSpec.describe KcCourses::Concerns::MovePosition, type: :module do
  describe "基础字段" do
    it{
      @test = MovePositionTest.create
      expect(@test.respond_to? :position).to eq(true)
      expect(@test.respond_to? :prev).to eq(true)
      expect(@test.respond_to? :next).to eq(true)
      expect(@test.respond_to? :move_up).to eq(true)
      expect(@test.respond_to? :move_down).to eq(true)

      expect(@test.respond_to? :set_position).to eq(true)

      expect(@test.position).not_to be_nil
      expect(@test.position).to be > 0
    }
  end

  describe KcCourses::Chapter, type: :model do
    before{
      @course = create(:course)
      @chapter1 = create(:chapter, course: @course, position: 1)
      @chapter2 = create(:chapter, course: @course, position: 2)
    }

    it{
      expect(@chapter1.prev).to eq(nil)
      expect(@chapter1.next).to eq(@chapter2)
      expect(@chapter2.prev).to eq(@chapter1)
      expect(@chapter2.next).to eq(nil)
    }

    it{
      expect(@chapter1.move_up).to be_nil
      expect(@chapter1.prev).to eq(nil)
      expect(@chapter1.next).to eq(@chapter2)
      expect(@chapter2.prev).to eq(@chapter1)
      expect(@chapter2.next).to eq(nil)
    }

    it{
      expect(@chapter1.move_down).not_to be_nil
      @chapter1.reload
      @chapter2.reload

      expect(@chapter1.prev).to eq(@chapter2)
      expect(@chapter1.next).to eq(nil)
      expect(@chapter2.prev).to eq(nil)
      expect(@chapter2.next).to eq(@chapter1)
    }
  end

  describe KcCourses::Ware, type: :model do
    before{
      @chapter = create(:chapter)
      @ware1 = create(:ware, chapter: @chapter, position: 1)
      @ware2 = create(:ware, chapter: @chapter, position: 2)
    }

    it{
      expect(@ware1.prev).to eq(nil)
      expect(@ware1.next).to eq(@ware2)
      expect(@ware2.prev).to eq(@ware1)
      expect(@ware2.next).to eq(nil)
    }

    it{
      expect(@ware1.move_up).to be_nil
      expect(@ware1.prev).to eq(nil)
      expect(@ware1.next).to eq(@ware2)
      expect(@ware2.prev).to eq(@ware1)
      expect(@ware2.next).to eq(nil)
    }

    it{
      expect(@ware1.move_down).not_to be_nil
      @ware1.reload
      @ware2.reload

      expect(@ware1.prev).to eq(@ware2)
      expect(@ware1.next).to eq(nil)
      expect(@ware2.prev).to eq(nil)
      expect(@ware2.next).to eq(@ware1)
    }
  end
end
