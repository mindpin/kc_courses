require 'rails_helper'

RSpec.describe KcCourses::WareReading, type: :model do
  describe "创建用户1，用户1学习课程1中的章节1中的小节1" do
    before{
      @user1 = FactoryGirl.create(:user)
      @course1 = FactoryGirl.create(:course, :user => @user1)
      @chapter1 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @ware1 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter1)
    }

    it{
      ware_reading1 = @ware1.set_read_percent_by_user(@user1, 58)
      expect(KcCourses::WareReading.count).to eq(1)
      expect(ware_reading1.read_percent).to eq(58)
      expect(@ware1.has_read_by_user?(@user1)).to eq(false)
      expect(@ware1.read_percent_of_user(@user1)).to eq(58)
    }

    it{
      time1 = Time.new.beginning_of_day
      time2 = Time.new.beginning_of_day + 1.day
      ware_reading_delta1 = @chapter1.set_read_percent_change_by_user(@user1, 20, time1)
      ware_reading_delta2 = @chapter1.set_read_percent_change_by_user(@user1, 80, time2)
      expect(KcCourses::WareReadingDelta.count).to eq(2)
      expect(ware_reading_delta2.read_percent_change).to eq(80)
      expect(@chapter1.has_read_by_user?(@user1)).to eq(true)
      expect(@chapter1.read_percent_change_of_user(@user1, time1)).to eq(20)
      expect(@chapter1.read_percent_of_user_before_time(@user1, time2)).to eq(100)
      expect(@user1.read_status_of_course(time1, time2)).to eq([ware_reading_delta1,ware_reading_delta2])
    }
  end
end