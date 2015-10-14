require 'rails_helper'

RSpec.describe KcCourses::JoinCourse, type: :model do
  describe "基础字段" do
    it{
      @join = create(:join_course)
      expect(@join.course).not_to be_nil
      expect(@join.user).not_to be_nil
    }

    it{
      @join = build(:join_course, user: nil, course: nil)
      @join.valid?
      expect(@join.errors[:user].size).to eq(1)
      expect(@join.errors[:course].size).to eq(1)
    }

    it "不能重复加入" do
      @user = create(:user)
      @course = create(:course)
      create(:join_course, user: @user, course: @course)
      @join = build(:join_course, user: @user, course: @course)
      @join.valid?
      expect(@join.errors[:course_id].size).to eq(1)
    end
  end
end



