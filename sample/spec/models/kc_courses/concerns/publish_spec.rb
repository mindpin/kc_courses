require 'rails_helper'

class PublishTest
  include Mongoid::Document
  include KcCourses::Concerns::Publish
end

RSpec.describe KcCourses::Concerns::MovePosition, type: :module do
  describe "基础字段" do
    it{
      @test = PublishTest.create
      expect(@test.respond_to? :published).to eq(true)
      expect(@test.respond_to? :publish!).to eq(true)
      expect(@test.respond_to? :unpublish!).to eq(true)

      expect(@test.published).to eq(false)
    }
  end

  describe KcCourses::Course, type: :model do
    before{
      @course = create(:course)
    }

    it{
      expect(@course.published).to eq(false)
    }

    it{
      expect(@course.publish!).to eq(true)
      expect(@course.published).to eq(true)
      expect(@course.unpublish!).to eq(true)
      expect(@course.published).to eq(false)
    }
  end
end

