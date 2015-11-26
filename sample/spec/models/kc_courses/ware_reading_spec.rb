require 'rails_helper'

RSpec.describe KcCourses::WareReading, type: :model do
  describe "测试用户1的学习进度" do
    before{
      @user1 = FactoryGirl.create(:user)
      @user2 = FactoryGirl.create(:user)
      @course1 = FactoryGirl.create(:course, :user => @user1)
      @course2 = FactoryGirl.create(:course, :user => @user1)
      @course3 = FactoryGirl.create(:course, :user => @user1)
      @course4 = FactoryGirl.create(:course, :user => @user1)
      @course5 = FactoryGirl.create(:course, :user => @user1)
      @chapter1 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @chapter2 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @chapter3 = FactoryGirl.create(:chapter, :user => @user1, :course => @course1)
      @ware11 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter1)
      @ware12 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter1)
      @ware21 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter2)
      @ware22 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter2)
      @ware31 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter3)
      @ware32 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter3)
      @chapter4 = FactoryGirl.create(:chapter, :user => @user1, :course => @course2)
      @ware41 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter4)
      @chapter5 = FactoryGirl.create(:chapter, :user => @user1, :course => @course3)
      @ware51 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter5)
      @chapter6 = FactoryGirl.create(:chapter, :user => @user1, :course => @course4)
      @ware61 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter6)
      @ware62 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter6)
      @chapter7 = FactoryGirl.create(:chapter, :user => @user1, :course => @course5)
      @ware71 = FactoryGirl.create(:ware, :user => @user1, :chapter => @chapter7)
    }

    it{
      @ware11.set_read_percent_by_user(@user1, 100)
      expect(@ware11.read_percent_of_user(@user1)).to eq(100) 
      expect(@ware11.chapter.read_percent_of_user(@user1)).to eq(50)
      expect(@ware11.chapter.course.read_percent_of_user(@user1)).to eq(16) 
      expect(@ware11.has_read_by_user?(@user1)).to eq(true) 
      expect(@ware11.chapter.has_read_by_user?(@user1)).to eq(false) 
      expect(@ware11.chapter.course.has_read_by_user?(@user1)).to eq(false)
      @ware12.set_read_percent_by_user(@user1, 100)
      expect(@ware11.chapter.read_percent_of_user(@user1)).to eq(100)
      expect(@ware11.chapter.course.read_percent_of_user(@user1)).to eq(33)
      expect(@ware11.chapter.has_read_by_user?(@user1)).to eq(true)
      @ware21.set_read_percent_by_user(@user1, 100)
      expect(@ware11.chapter.course.read_percent_of_user(@user1)).to eq(50)
      @ware22.set_read_percent_by_user(@user1, 100)
      expect(@ware11.chapter.course.read_percent_of_user(@user1)).to eq(66)
      @ware31.set_read_percent_by_user(@user1, 100)
      expect(@ware11.chapter.course.read_percent_of_user(@user1)).to eq(83)
      @ware32.set_read_percent_by_user(@user1, 100)
      expect(@ware11.chapter.course.read_percent_of_user(@user1)).to eq(100) 
    }

    it{
      time1 = Time.new
      time2 = Time.new + 1.day
      @ware12.set_read_percent_change_by_user(@user1, 58, time1)
      expect(@ware12.has_read_by_user?(@user1)).to eq(false)
      expect(@ware12.chapter.has_read_by_user?(@user1)).to eq(false)
      expect(@ware12.chapter.course.has_read_by_user?(@user1)).to eq(false)
      expect(@ware12.read_percent_of_user(@user1)).to eq(58)
      expect(@ware12.chapter.read_percent_of_user(@user1)).to eq(29)
      expect(@ware12.chapter.course.read_percent_of_user(@user1)).to eq(9)
      expect(@ware12.read_percent_change_of_user(@user1, time1)).to eq(58)
      expect(@ware12.chapter.read_percent_change_of_user(@user1, time1)).to eq(29)
      expect(@ware12.chapter.course.read_percent_change_of_user(@user1, time1)).to eq(9)
      @ware12.set_read_percent_change_by_user(@user1, 42, time2)
      expect(@ware12.read_percent_of_user(@user1)).to eq(100)
      expect(@ware12.chapter.read_percent_of_user(@user1)).to eq(50)
      expect(@ware12.chapter.course.read_percent_of_user(@user1)).to eq(16)
      expect(@ware12.has_read_by_user?(@user1)).to eq(true)
      # 测试 @user1 截止到time2（包括这个某天内学习的），已经学习了 course/chapter/ware 多少百分比的内容
      expect(@ware12.read_percent_of_user_before_time(@user1, time2)).to eq(100)
      expect(@ware12.chapter.read_percent_of_user_before_time(@user1, time2)).to eq(50)
      expect(@ware12.chapter.course.read_percent_of_user_before_time(@user1, time2)).to eq(16)
    }

    it{
      time1 = Time.new
      time2 = Time.new + 1.day
      expect(@ware32.read_percent_of_user(@user1)).to eq(0)
      expect(@ware32.read_percent_change_of_user(@user1, time1)).to eq(0)
      expect(@ware32.read_percent_of_user_before_time(@user1, time2)).to eq(0)
    }


    it{
      time1 = Time.new
      time2 = Time.new + 1.day
      time3 = Time.new + 2.day
      ware_reading_delta1 = @ware11.set_read_percent_change_by_user(@user1, 100, time1)
      ware_reading_delta2 = @ware12.set_read_percent_change_by_user(@user1, 100, time2)

      expect(@user1.read_status_of_course(time1, time1)).to eq([@ware11.chapter.ware_reading_deltas.first,@ware11.chapter.course.ware_reading_deltas.first,ware_reading_delta1])
      expect(@user1.read_status_of_course(time1, time2)).to eq([ware_reading_delta2,@ware11.chapter.ware_reading_deltas.first,@ware11.chapter.course.ware_reading_deltas.first,ware_reading_delta1,@ware12.chapter.ware_reading_deltas.last,@ware12.chapter.course.ware_reading_deltas.last])
    }

    it{
      ware_reading1 = @ware11.set_read_percent_by_user(@user2, 100)
      ware_reading2 = @ware41.set_read_percent_by_user(@user2, 100)
      ware_reading3 = @ware51.set_read_percent_by_user(@user2, 100)
      ware_reading4 = @ware61.set_read_percent_by_user(@user2, 100)
      ware_reading5 = @ware71.set_read_percent_by_user(@user2, 100)
      expect(KcCourses::Course.studing_of_user(@user2)).to eq([@course1,@course4])
      expect(KcCourses::Course.studied_of_user(@user2)).to eq([@course2,@course3,@course5])
    }
  end
end
