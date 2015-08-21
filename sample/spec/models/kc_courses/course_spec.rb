require 'rails_helper'

RSpec.describe KcCourses::Course, type: :model do
  describe "基础字段" do
    it{
      @course = create(:course)
      expect(@course.title).to eq("课程1")
      expect(@course.desc).to eq("课程1 描述")
    }

    it{
      @course = build(:course, title: '')
      @course.valid?
      expect(@course.errors[:title].size).to eq(1)
    }
  end
end
