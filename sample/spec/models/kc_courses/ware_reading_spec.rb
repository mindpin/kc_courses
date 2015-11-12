require 'rails_helper'

RSpec.describe KcCourses::WareReading, type: :model do
  describe "创建用户1，测试用户1的学习进度" do
    before{
      @user1 = FactoryGirl.create(:user)
      @course1 = FactoryGirl.create(:course, :user => @user1)
      @chapter1 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @chapter2 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @chapter3 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @ware11 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter1)
      @ware12 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter1)
      @ware21 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter2)
      @ware22 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter2)
      @ware31 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter3)
      @ware32 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter3)
    }

    it{
      ware_reading1 = @ware11.set_read_percent_by_user(@user1, 58)
      expect(KcCourses::WareReading.count).to eq(1)
      expect(ware_reading1.read_percent).to eq(58)
      expect(@ware11.has_read_by_user?(@user1)).to eq(false)
      expect(@ware11.read_percent_of_user(@user1)).to eq(58)
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

    it{
      time1 = Time.new.beginning_of_day
      ware_reading_delta1 = @chapter2.set_read_percent_change_by_user(@user1, 60, time1)
      expect(KcCourses::WareReading.count).to eq(1)
      expect(ware_reading_delta1.read_percent_change).to eq(60)
      expect(ware_reading_delta1.read_percent).to eq(60)
    }

    it{
      time1 = Time.new.beginning_of_day
      ware_reading_delta1 = @course1.set_read_percent_change_by_user(@user1, 20, time1)
      ware_reading_delta2 = @chapter2.set_read_percent_change_by_user(@user1, 30, time1)
      expect(@course1.has_read_by_user?(@user1)).to eq(false)
      expect(@chapter2.read_percent_of_user_before_time(@user1, time1)).to eq(30)
    }

    it{
      time1 = Time.new.beginning_of_day
      time2 = Time.new.beginning_of_day + 1.day
      time3 = Time.new.beginning_of_day + 2.day
      ware_reading_delta1 = @course1.set_read_percent_change_by_user(@user1, 30, time1)
      ware_reading_delta2 = @course1.set_read_percent_change_by_user(@user1, 35, time2)
      ware_reading_delta3 = @course1.set_read_percent_change_by_user(@user1, 35, time3)
      ware_reading_delta4 = @chapter1.set_read_percent_change_by_user(@user1, 90, time1)
      ware_reading_delta5 = @chapter1.set_read_percent_change_by_user(@user1, 10, time2)
      ware_reading_delta6 = @chapter2.set_read_percent_change_by_user(@user1, 100, time2)
      ware_reading_delta7 = @chapter3.set_read_percent_change_by_user(@user1, 100, time3)
      ware_reading_delta8 = @ware11.set_read_percent_change_by_user(@user1, 100, time1)
      ware_reading_delta9 = @ware12.set_read_percent_change_by_user(@user1, 100, time1)
      ware_reading_delta10 = @ware21.set_read_percent_change_by_user(@user1, 100, time2)
      ware_reading_delta11 = @ware22.set_read_percent_change_by_user(@user1, 100, time2)
      ware_reading_delta12 = @ware31.set_read_percent_change_by_user(@user1, 100, time3)
      ware_reading_delta13 = @ware32.set_read_percent_change_by_user(@user1, 100, time3)
      expect(@course1.has_read_by_user?(@user1)).to eq(true)
      expect(@chapter1.has_read_by_user?(@user1)).to eq(true)
      expect(@course1.read_percent_of_user_before_time(@user1, time2)).to eq(65)
      expect(@course1.read_percent_change_of_user(@user1, time2)).to eq(35)
      expect(@user1.read_status_of_course(time1, time3)).to eq([ware_reading_delta1,ware_reading_delta2,ware_reading_delta3,ware_reading_delta4,ware_reading_delta5,ware_reading_delta6,ware_reading_delta7,ware_reading_delta8,ware_reading_delta9,ware_reading_delta10,ware_reading_delta11,ware_reading_delta12,ware_reading_delta13])
      expect(@user1.read_status_of_course(time1, time2)).to eq([ware_reading_delta1,ware_reading_delta2,nil,ware_reading_delta4,ware_reading_delta5,ware_reading_delta6,nil,ware_reading_delta8,ware_reading_delta9,ware_reading_delta10,ware_reading_delta11,nil,nil])
    }
  end
end
