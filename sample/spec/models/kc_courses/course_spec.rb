require 'rails_helper'

RSpec.describe KcCourses::Course, type: :model do
  describe "基础字段" do
    it{
      @course = create(:course)
      expect(@course.title).to eq("课程1")
      expect(@course.desc).to eq("课程1 描述")
      expect(@course.user).not_to be_nil
    }

    it{
      @course = build(:course, title: '')
      @course.valid?
      expect(@course.errors[:title].size).to eq(1)
    }

    it{
      @course = build(:course, user: nil)
      @course.valid?
      expect(@course.errors[:user].size).to eq(1)
    }

    it 'recent' do
      expect(KcCourses::Course.respond_to? :recent).to eq(true)
      @course = create(:course)
      expect(KcCourses::Course.recent.first).to eq(@course)
    end

    it 'hot' do
      expect(KcCourses::Course.respond_to? :hot).to eq(true)
      # TODO 添加热门课程对应的测试
    end

    it 'studing_of_user(user)  studied_of_user(user)' do
      expect(KcCourses::Course.respond_to? :studing_of_user).to eq(true)
      expect(KcCourses::Course.respond_to? :studied_of_user).to eq(true)
      user = create(:user)

      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)

      course2 = create(:course)
      chapter21 = create(:chapter, :course => course2)
      ware211 = create(:ware, :chapter => chapter21)

      course3 = create(:course)
      chapter31 = create(:chapter, :course => course3)
      ware311 = create(:ware, :chapter => chapter31)

      course4 = create(:course)
      chapter41 = create(:chapter, :course => course4)
      ware411 = create(:ware, :chapter => chapter41)

      course5 = create(:course)
      chapter51 = create(:chapter, :course => course5)
      ware511 = create(:ware, :chapter => chapter51)
      #课程一 已做完
      ware111.set_read_percent_by_user(user, 100)
      #课程二 完成了 60
      ware211.set_read_percent_by_user(user, 60)
      #课程三 已做完
      ware311.set_read_percent_by_user(user, 100)
      #课程四 完成了 25
      ware411.set_read_percent_by_user(user, 25)
      #课程五 没做过
      

      expect(KcCourses::Course.studing_of_user(user)).to eq([course2,course4])
      expect(KcCourses::Course.studied_of_user(user)).to eq([course1,course3])
    end
  end
end
