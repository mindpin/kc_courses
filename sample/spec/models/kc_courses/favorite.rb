require 'rails_helper'

RSpec.describe KcCourses::Favorite, type: :model do
  describe "基础字段" do
    it{
      @favorite = create(:favorite)
      expect(@favorite.course).not_to be_nil
      expect(@favorite.user).not_to be_nil
    }

    it{
      @favorite = build(:favorite, user: nil, course: nil)
      @favorite.valid?
      expect(@favorite.errors[:user].size).to eq(1)
      expect(@favorite.errors[:course].size).to eq(1)
    }

    it "不能重复收藏" do
      @user = create(:user)
      @course = create(:course)
      create(:favorite, user: @user, course: @course)
      @favorite = build(:favorite, user: @user, course: @course)
      @favorite.valid?
      expect(@favorite.errors[:course_id].size).to eq(1)
    end
  end
end


