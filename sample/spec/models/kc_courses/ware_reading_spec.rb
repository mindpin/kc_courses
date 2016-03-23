require 'rails_helper'

RSpec.describe KcCourses::WareReading, type: :model do
  before(:each){
    # 客户信息
    # 第一章客户信息管理
    # 1_1_客户账户调整
    # 1_2_测试菜单
    # 第二章查询客户信息
    # 2_1_查询客户号
    # 2_2_查询客户账户调整
    # 2_3_查询客户信息维护
    # 2_4_查询个人客户基本信息
    # 2_5_查询单位客户基本信息
    # 第三章建立客户信息
    # 3_1_新建个人客户基本信息
    # 3_2_新建对公客户基本信息
    # 3_3_编不下去了
    course_creator = create(:user)
    @course_客户信息 = KcCourses::Course.create(
      :title => "客户信息",
      :creator  => course_creator
    )

    @chapter_第一章客户信息管理 = @course_客户信息.chapters.create(
      :title => "第一章客户信息管理",
      :creator  => course_creator
    )

    @ware_1_1_客户账户调整 = @chapter_第一章客户信息管理.wares.create(
      :title => "1_1_客户账户调整",
      :creator  => course_creator
    )

    @ware_1_2_测试菜单 = @chapter_第一章客户信息管理.wares.create(
      :title => "1_2_测试菜单",
      :creator  => course_creator
    )


    @chapter_第二章查询客户信息 = @course_客户信息.chapters.create(
      :title => "第二章查询客户信息",
      :creator  => course_creator
    )

    @ware_2_1_查询客户号 = @chapter_第二章查询客户信息.wares.create(
      :title => "2_1_查询客户号",
      :creator  => course_creator
    )

    @ware_2_2_查询客户账户调整 = @chapter_第二章查询客户信息.wares.create(
      :title => "2_2_查询客户账户调整",
      :creator  => course_creator
    )


    @ware_2_3_查询客户信息维护 = @chapter_第二章查询客户信息.wares.create(
      :title => "2_3_查询客户信息维护",
      :creator  => course_creator
    )

    @ware_2_4_查询个人客户基本信息 = @chapter_第二章查询客户信息.wares.create(
      :title => "2_4_查询个人客户基本信息",
      :creator  => course_creator
    )

    @ware_2_5_查询单位客户基本信息 = @chapter_第二章查询客户信息.wares.create(
      :title => "2_5_查询单位客户基本信息",
      :creator  => course_creator
    )

    @chapter_第三章建立客户信息 = @course_客户信息.chapters.create(
      :title => "第三章建立客户信息",
      :creator  => course_creator
    )

    @ware_3_1_新建个人客户基本信息 = @chapter_第三章建立客户信息.wares.create(
      :title => "3_1_新建个人客户基本信息",
      :creator  => course_creator
    )

    @ware_3_2_新建对公客户基本信息 = @chapter_第三章建立客户信息.wares.create(
      :title => "3_2_新建对公客户基本信息",
      :creator  => course_creator
    )

    @ware_3_3_编不下去了 = @chapter_第三章建立客户信息.wares.create(
      :title => "3_3_编不下去了",
      :creator  => course_creator
    )
  }

  describe "ware.set_read_percent_by_user(user, read_percent), ware.has_read_by_user?(user), ware.read_percent_of_user(user)" do
    def expect_ware_info(ware, user, has_read, percent)
      expect(ware.has_read_by_user?(user)).to eq(has_read)
      expect(ware.read_percent_of_user(user)).to eq(percent)
    end

    before(:each){
      @user   = create(:user)
    }

    it{
      expect_ware_info(@ware_1_1_客户账户调整, @user, false, 0)
    }

    it{
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 50)
      expect_ware_info(@ware_1_1_客户账户调整, @user, false, 50)
    }

    it{
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 100)
      expect_ware_info(@ware_1_1_客户账户调整, @user, true, 100)
    }

    describe "ware.set_read_percent_by_user(user, read_percent) 不能设置小于当前百分比的数值" do
      it{
        @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 50)
        expect_ware_info(@ware_1_1_客户账户调整, @user, false, 50)

        @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 10)
        expect_ware_info(@ware_1_1_客户账户调整, @user, false, 50)
      }
    end
  end

  describe "chapter.has_read_by_user?(user) chapter.read_percent_of_user(user)" do
    def expect_chapter_info(chapter, user, has_read, percent)
      expect(chapter.has_read_by_user?(user)).to eq(has_read)
      expect(chapter.read_percent_of_user(user)).to eq(percent)
    end

    before(:each){
      # 客户信息
      # 第一章客户信息管理
      # 1_1_客户账户调整
      # 1_2_测试菜单
      @user   = create(:user)
    }

    # 两个全没做过
    it{
      expect_chapter_info(@chapter_第一章客户信息管理, @user, false, 0)
    }

    # 其中一个做过一部分，另一个没做
    it{
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 40)
      expect_chapter_info(@chapter_第一章客户信息管理, @user, false, 20)
    }

    # 其中一个做完，另一个没做
    it{
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 100)
      expect_chapter_info(@chapter_第一章客户信息管理, @user, false, 50)
    }

    # 其中一个做完，另一个做完一部分
    it{
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 100)
      @ware_1_2_测试菜单.set_read_percent_by_user(@user, 40)

      expect_chapter_info(@chapter_第一章客户信息管理, @user, false, 70)
    }

    # 两个都做完
    it{
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 100)
      @ware_1_2_测试菜单.set_read_percent_by_user(@user, 100)

      expect_chapter_info(@chapter_第一章客户信息管理, @user, true, 100)
    }

    describe "chapter.wares.count == 0 时" do
      it{
        course = create(:course)
        chapter = create(:chapter, :course => course)
        user = create(:user)
        expect(chapter.read_percent_of_user(user)).to eq(0)
      }
    end
  end

  describe "course.has_read_by_user?(user) course.read_percent_of_user(user)" do
    before(:each){
      # 客户信息
      # 第一章客户信息管理
      # 1_1_客户账户调整
      # 1_2_测试菜单
      # 第二章查询客户信息
      # 2_1_查询客户号
      # 2_2_查询客户账户调整
      # 2_3_查询客户信息维护
      # 2_4_查询个人客户基本信息
      # 2_5_查询单位客户基本信息
      # 第三章建立客户信息
      # 3_1_新建个人客户基本信息
      # 3_2_新建对公客户基本信息
      # 3_3_编不下去了
      @user   = create(:user)
    }

    # ware 完全没有做过
    it{
      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(0)
    }

    # chapter 下，存在部分完成的 ware,完全没有做过的 ware
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 50)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 50)
      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(11)
    }

    # chapter 下，只存在部分完成的 ware
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 50)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 50)
      @ware_3_3_编不下去了.set_read_percent_by_user(@user, 50)

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(16)
    }

    # chapter 下，存在全部完成的 ware,部分完成的 ware,没有做过的 ware
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 50)

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(16)
    }

    # chapter 下，存在全部完成的 ware,部分完成的 ware
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 50)
      @ware_3_3_编不下去了.set_read_percent_by_user(@user, 50)

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(22)
    }

    # chapter 下，存在全部完成的 ware,没有做过的 ware
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 100)

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(22)
    }
    # 一个 chapter 全部完成，另外的 chapter 没有做过
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_3_编不下去了.set_read_percent_by_user(@user, 100)

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(33)
    }

    # 一个 chapter 全部完成，另外的 chapter 部分完成
    it{
      @ware_3_1_新建个人客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_2_新建对公客户基本信息.set_read_percent_by_user(@user, 100)
      @ware_3_3_编不下去了.set_read_percent_by_user(@user, 100)
      @ware_1_1_客户账户调整.set_read_percent_by_user(@user, 50)

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(false)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(41)
    }

    # chpater 全部完成
    it{
      @course_客户信息.chapters.each do |chapter|
        chapter.wares.each do |ware|
          ware.set_read_percent_by_user(@user, 100)
        end
      end

      expect(@course_客户信息.has_read_by_user?(@user)).to eq(true)
      expect(@course_客户信息.read_percent_of_user(@user)).to eq(100)
    }


    describe "course.chapters.count == 0 时" do
      it{
        course = create(:course)
        user = create(:user)
        expect(course.read_percent_of_user(user)).to eq(0)
      }
    end

    describe "course.chapters[random].wares.count == 0 时" do
      it{
        course = create(:course)
        create(:chapter, :course => course)
        ware = create(:ware, :chapter => create(:chapter, :course => course))
        user = create(:user)
        expect(course.read_percent_of_user(user)).to eq(0)
        ware.set_read_percent_by_user(user, 50)
        expect(course.read_percent_of_user(user)).to eq(25)
      }
    end
  end

  describe "ware.read_percent_change_of_user(user, time) ware.read_percent_of_user_before_day(user, time)" do
    before(:each){
      @day_1 = Time.local(2012, 12, 22, 10, 0, 0)
      @day_2 = Time.local(2012, 12, 23, 10, 0, 0)
      @day_3 = Time.local(2012, 12, 24, 10, 0, 0)
      @day_4 = Time.local(2012, 12, 25, 10, 0, 0)

      @ware = @ware_1_1_客户账户调整
      @user = create(:user)

      # ware 第一天没有学习，进度是 0，变化是 0
      [
        # ware 第二天进行了学习，进度是 20，变化是 20
        [@day_2 - 2.minute, @ware, @user,  10],
        [@day_2 - 1.minute, @ware, @user,  20],
        # ware 第三天进行了学习，进度是 50，变化是 30
        [@day_3,            @ware, @user,  50],
        # ware 第四天进行了学习，进度是 100， 变化是 50
        [@day_4 - 5.minute, @ware, @user,  60],
        [@day_4 - 4.minute, @ware, @user,  70],
        [@day_4 - 3.minute, @ware, @user,  80],
        [@day_4,            @ware, @user, 100]
      ].each do |arr|
        Timecop.freeze(arr[0]) do
          arr[1].set_read_percent_by_user(arr[2], arr[3])
        end

      end
    }

    it{
      [
        # ware 第一天没有学习，进度是 0，变化是 0
        [@ware, @user, @day_1,  0,   0],
        # ware 第二天进行了学习，进度是 20，变化是 20
        [@ware, @user, @day_2, 20,  20],
        # ware 第三天进行了学习，进度是 50，变化是 30
        [@ware, @user, @day_3, 30,  50],
        # ware 第四天进行了学习，进度是 100， 变化是 50
        [@ware, @user, @day_4, 50, 100]
      ].each do |arr|
        expect(arr[0].read_percent_change_of_user(arr[1], arr[2])).to eq(arr[3])
        expect(arr[0].read_percent_of_user_before_day(arr[1], arr[2])).to eq(arr[4])
      end

    }
  end

  describe "chapter.read_percent_change_of_user(user, time) chapter.read_percent_of_user_before_day(user, time)" do
    before(:each){
      @day_1 = Time.local(2012, 12, 22, 10, 0, 0)
      @day_2 = Time.local(2012, 12, 23, 10, 0, 0)
      @day_3 = Time.local(2012, 12, 24, 10, 0, 0)
      @day_4 = Time.local(2012, 12, 25, 10, 0, 0)
      @day_5 = Time.local(2012, 12, 26, 10, 0, 0)

      # 客户信息
      # 第一章客户信息管理
      # 1_1_客户账户调整
      # 1_2_测试菜单
      @user   = create(:user)

      # 第一天 两个全没做过
      [
        # 第二天 1_1 学习了 50
        [@ware_1_1_客户账户调整, @user, @day_2,  50],
        # 第三天 1_1 学习到了 100，1_2 没学
        [@ware_1_1_客户账户调整, @user, @day_3, 100],
        # 第四天 1_1 学习到了 100，1_2 学习到了 50
        [@ware_1_2_测试菜单,    @user, @day_4,  50],
        # 第五天 两个都做完
        [@ware_1_2_测试菜单,    @user, @day_5, 100]
      ].each do |arr|
        Timecop.freeze(arr[2]) do
          arr[0].set_read_percent_by_user(arr[1], arr[3])
        end
      end

    }

    it{
      [
        # 第一天 两个全没做过
        [@chapter_第一章客户信息管理, @user, @day_1,  0,  0],
        # 第二天 1_1 学习到了 50，1_2 没学
        [@chapter_第一章客户信息管理, @user, @day_2, 25, 25],
        # 第三天 1_1 学习到了 100，1_2 没学
        [@chapter_第一章客户信息管理, @user, @day_3, 25, 50],
        # 第四天 1_1 学习到了 100，1_2 学习到了 50
        [@chapter_第一章客户信息管理, @user, @day_4, 25, 75],
        # 第五天 两个都做完
        [@chapter_第一章客户信息管理, @user, @day_5, 25, 100]
      ].each do |arr|
        expect(arr[0].read_percent_change_of_user(arr[1], arr[2])).to eq(arr[3])
        expect(arr[0].read_percent_of_user_before_day(arr[1], arr[2])).to eq(arr[4])
      end
    }

    describe "chapter.wares.count == 0 时" do
      it{
        course = create(:course)
        chapter = create(:chapter, :course => course)
        user = create(:user)
        expect(chapter.read_percent_change_of_user(user, Time.zone.now)).to eq(0)
        expect(chapter.read_percent_of_user_before_day(user, Time.zone.now)).to eq(0)
      }
    end
  end

  describe "course.read_percent_change_of_user(user, time) course.read_percent_of_user_before_day(user, time) " do
    before(:each){
      @day_1 = Time.local(2012, 12, 22, 10, 0, 0)
      @day_2 = Time.local(2012, 12, 23, 10, 0, 0)
      @day_3 = Time.local(2012, 12, 24, 10, 0, 0)
      @day_4 = Time.local(2012, 12, 25, 10, 0, 0)
      @day_5 = Time.local(2012, 12, 26, 10, 0, 0)
      @day_6 = Time.local(2012, 12, 27, 10, 0, 0)
      @day_7 = Time.local(2012, 12, 28, 10, 0, 0)
      @day_8 = Time.local(2012, 12, 29, 10, 0, 0)

      # 客户信息
      # 第一章客户信息管理
      # 1_1_客户账户调整
      # 1_2_测试菜单
      # 第二章查询客户信息
      # 2_1_查询客户号
      # 2_2_查询客户账户调整
      # 2_3_查询客户信息维护
      # 2_4_查询个人客户基本信息
      # 2_5_查询单位客户基本信息
      # 第三章建立客户信息
      # 3_1_新建个人客户基本信息
      # 3_2_新建对公客户基本信息
      # 3_3_编不下去了
      @user   = create(:user)

      # 第一天 完全没有做过
      [
        # 第二天 chapter_1 下，ware_1_1 完成了 50
        [@day_2, @ware_1_1_客户账户调整, @user, 50],
        # 第三天 chapter_3 下，ware_3_1 全部完成，ware_3_2 完成了 50
        [@day_3, @ware_3_1_新建个人客户基本信息, @user, 100],
        [@day_3, @ware_3_2_新建对公客户基本信息, @user, 50],
        # 第四天 chapter_1 下，ware_1_2 完成了 50
        [@day_4, @ware_1_2_测试菜单, @user, 50],
        # 第五天 chapter_1 下，ware_1_1 完成了 100
        [@day_5, @ware_1_1_客户账户调整, @user, 100],
        # 第六天 chapter—_3 下，ware_3_2 完成了 100
        [@day_6, @ware_3_2_新建对公客户基本信息, @user, 100],
        # 第七天 chapter_1 下 ware_1_2 完成 100
        [@day_7, @ware_1_2_测试菜单, @user, 100]
      ].each do |arr|
        Timecop.freeze(arr[0]) do
          arr[1].set_read_percent_by_user(arr[2], arr[3])
        end
      end

      # 第八天 全部完成
      Timecop.freeze(@day_8) do
        @course_客户信息.chapters.each do |chapter|
          chapter.wares.each do |ware|
            ware.set_read_percent_by_user(@user, 100)
          end
        end
      end
    }

    it{
      [
        # 第一天 完全没有做过
        [@course_客户信息, @user, @day_1,  0,   0],
        # 第二天 chapter_1 下，ware_1_1 完成了 50
        [@course_客户信息, @user, @day_2,  8,   8],
        # 第三天 chapter_3 下，ware_3_1 全部完成，ware_3_2 完成了 50
        [@course_客户信息, @user, @day_3, 16,  25],
        # 第四天 chapter_1 下，ware_1_2 完成了 50
        [@course_客户信息, @user, @day_4,  8,  33],
        # 第五天 chapter_1 下，ware_1_1 完成了 100
        [@course_客户信息, @user, @day_5,  8,  41],
        # 第六天 chapter—_3 下，ware_3_2 完成了 100
        [@course_客户信息, @user, @day_6,  5,  47],
        # 第七天 chapter_1 下 ware_1_2 完成 100
        [@course_客户信息, @user, @day_7,  8,  55],
        # 第八天 全部完成
        [@course_客户信息, @user, @day_8, 44, 100]
      ].each do |arr|
        expect(arr[0].read_percent_change_of_user(arr[1], arr[2])).to eq(arr[3])
        expect(arr[0].read_percent_of_user_before_day(arr[1], arr[2])).to eq(arr[4])
      end

    }

    describe "course.chapters.count == 0 时" do
      it{
        course = create(:course)
        user = create(:user)

        expect(course.read_percent_change_of_user(user, Time.zone.now)).to eq(0)
        expect(course.read_percent_of_user_before_day(user, Time.zone.now)).to eq(0)
      }
    end

    describe "course.chapters[random].wares.count == 0 时" do
      it{
        course = create(:course)
        create(:chapter, :course => course)
        ware = create(:ware, :chapter => create(:chapter, :course => course))
        user = create(:user)

        expect(course.read_percent_change_of_user(user, Time.zone.now)).to eq(0)
        expect(course.read_percent_of_user_before_day(user, Time.zone.now)).to eq(0)


        ware.set_read_percent_by_user(user, 50)

        expect(course.read_percent_change_of_user(user, Time.zone.now)).to eq(25)
        expect(course.read_percent_of_user_before_day(user, Time.zone.now)).to eq(25)
      }
    end

  end

end
