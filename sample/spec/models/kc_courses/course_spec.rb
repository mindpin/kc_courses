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

      expect(KcCourses::Course.studing_of_user(nil).class.name).to eq('Mongoid::Criteria')
      expect(KcCourses::Course.studied_of_user(nil).class.name).to eq('Mongoid::Criteria')
      
      expect(KcCourses::Course.studing_of_user(user).class.name).to eq('Mongoid::Criteria')
      expect(KcCourses::Course.studied_of_user(user).class.name).to eq('Mongoid::Criteria')

      expect(KcCourses::Course.studing_of_user(user).count).to eq(2)
      expect(KcCourses::Course.studied_of_user(user).last).to eq(course3)
    end
  end

  describe "@course.studing_ware_of_user(user)" do
    #课程中没有课件
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)

      expect(course1.studing_ware_of_user(user)).to eq(nil) 
    }
    #没有学习记录
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)

      expect(course1.studing_ware_of_user(user)).to eq(nil)
    }
    #存在课件有学习记录，也存在课件没有学习记录,最后的学习记录没有学习 100%
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware111.set_read_percent_by_user(user, 50)

      expect(course1.studing_ware_of_user(user)).to eq(ware111)
    }
    #存在课件有学习记录，也存在课件没有学习记录,最后的学习记录学习了 100%
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware111.set_read_percent_by_user(user, 100)

      expect(course1.studing_ware_of_user(user)).to eq(ware112)
    }
    #所有课件都有学习记录但最后一个课件的学习记录没有学习 100%
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware111.set_read_percent_by_user(user, 100)
      ware112.set_read_percent_by_user(user, 60)

      expect(course1.studing_ware_of_user(user)).to eq(ware112)
    }
    #所有课件都有学习记录且所有的学习记录都是学习 100%
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware111.set_read_percent_by_user(user, 100)
      ware112.set_read_percent_by_user(user, 100)

      expect(course1.studing_ware_of_user(user)).to eq(nil)
    }
    #最新学习记录是 100%，倒数第二个（或者N个）不是 100%（这个除非是学习后，课程被修改。应该返回未学习且安排序最考前的课件）
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware113 = create(:ware, :chapter => chapter11)
      ware111.set_read_percent_by_user(user, 100)
      ware111.set_read_percent_by_user(user, 100)
      ware112 = create(:ware, :chapter => chapter11)

      expect(course1.studing_ware_of_user(user)).to eq(ware112)
    }
  end
end
