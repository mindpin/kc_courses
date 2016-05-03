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
      :name => "客户信息",
      :creator  => course_creator
    )

    @chapter_第一章客户信息管理 = @course_客户信息.chapters.create(
      :name => "第一章客户信息管理",
      :creator  => course_creator
    )

    @ware_1_1_客户账户调整 = @chapter_第一章客户信息管理.wares.create(
      :name => "1_1_客户账户调整",
      :creator  => course_creator
    )

    @ware_1_2_测试菜单 = @chapter_第一章客户信息管理.wares.create(
      :name => "1_2_测试菜单",
      :creator  => course_creator
    )


    @chapter_第二章查询客户信息 = @course_客户信息.chapters.create(
      :name => "第二章查询客户信息",
      :creator  => course_creator
    )

    @ware_2_1_查询客户号 = @chapter_第二章查询客户信息.wares.create(
      :name => "2_1_查询客户号",
      :creator  => course_creator
    )

    @ware_2_2_查询客户账户调整 = @chapter_第二章查询客户信息.wares.create(
      :name => "2_2_查询客户账户调整",
      :creator  => course_creator
    )


    @ware_2_3_查询客户信息维护 = @chapter_第二章查询客户信息.wares.create(
      :name => "2_3_查询客户信息维护",
      :creator  => course_creator
    )

    @ware_2_4_查询个人客户基本信息 = @chapter_第二章查询客户信息.wares.create(
      :name => "2_4_查询个人客户基本信息",
      :creator  => course_creator
    )

    @ware_2_5_查询单位客户基本信息 = @chapter_第二章查询客户信息.wares.create(
      :name => "2_5_查询单位客户基本信息",
      :creator  => course_creator
    )

    @chapter_第三章建立客户信息 = @course_客户信息.chapters.create(
      :name => "第三章建立客户信息",
      :creator  => course_creator
    )

    @ware_3_1_新建个人客户基本信息 = @chapter_第三章建立客户信息.wares.create(
      :name => "3_1_新建个人客户基本信息",
      :creator  => course_creator
    )

    @ware_3_2_新建对公客户基本信息 = @chapter_第三章建立客户信息.wares.create(
      :name => "3_2_新建对公客户基本信息",
      :creator  => course_creator
    )

    @ware_3_3_编不下去了 = @chapter_第三章建立客户信息.wares.create(
      :name => "3_3_编不下去了",
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

end
