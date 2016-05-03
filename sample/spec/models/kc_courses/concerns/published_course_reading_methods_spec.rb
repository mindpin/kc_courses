require 'rails_helper'

RSpec.describe KcCourses::Concerns::PublishedCourseReadingMethods, type: :module do
  describe KcCourses::PublishedCourse, type: :model do
    before do
      @user = create(:user)

      @course = create(:course)
      @chapter1 = create(:chapter, course: @course)
      @ware11 = create(:ware, chapter: @chapter1)
      @ware12 = create(:ware, chapter: @chapter1)
      @ware13 = create(:ware, chapter: @chapter1)
      @chapter2 = create(:chapter, course: @course)
      @ware21 = create(:ware, chapter: @chapter2)
      @ware22 = create(:ware, chapter: @chapter2)
      @ware23 = create(:ware, chapter: @chapter2)

      @chapters = [@chapter1, @chapter2]
      @wares = []
      @wares.push @ware11
      @wares.push @ware12
      @wares.push @ware13
      @wares.push @ware21
      @wares.push @ware22
      @wares.push @ware23

      @course.publish!
      @published_course = @course.published_course
    end

    it "published_chapters" do
      expect(@published_course.published_chapters.length).to eq @chapters.length
      expect(@published_course.published_chapters.map{|chapter| chapter['id']}.sort).to eq @chapters.map{|c| c.id.to_s}.sort
    end

    it "published_wares" do
      expect(@published_course.published_wares.length).to eq @wares.length
      expect(@published_course.published_wares.map{|ware| ware['id']}.sort).to eq @wares.map{|c| c.id.to_s}.sort
    end

    it "read_percent_of_user_with_published_ware" do
      @percent = 50
      @published_ware = @published_course.published_wares.first
      @ware = KcCourses::Ware.find @published_ware['id']

      expect(@published_course.read_percent_of_user_with_published_ware(@user, @published_ware)).to eq 0

      @ware.set_read_percent_by_user @user, @percent

      expect(@published_course.read_percent_of_user_with_published_ware(@user, @published_ware)).to eq @percent
    end

    it "read_percent_of_user_with_published_chapter" do
      @percent = 100
      @published_ware = @published_course.published_wares.first
      @published_chapter = @published_course.published_chapters.first
      @ware = KcCourses::Ware.find @published_ware['id']

      expect(@published_course.read_percent_of_user_with_published_chapter(@user, @published_chapter)).to eq 0

      @ware.set_read_percent_by_user @user, @percent

      expect(@published_course.read_percent_of_user_with_published_chapter(@user, @published_chapter)).to eq (@percent / 3.0).round
    end

    it "read_percent_of_user" do
      @percent = 100
      @published_ware = @published_course.published_wares.first
      @ware = KcCourses::Ware.find @published_ware['id']

      expect(@published_course.read_percent_of_user(@user)).to eq 0

      @ware.set_read_percent_by_user @user, @percent

      expect(@published_course.read_percent_of_user(@user)).to eq (@percent / @wares.length.to_f).round
    end

    it "极低比例，应该至少为1，表示已经读过" do
      @percent = 1
      @published_ware = @published_course.published_wares.first
      @ware = KcCourses::Ware.find @published_ware['id']

      expect(@published_course.read_percent_of_user(@user)).to eq 0

      @ware.set_read_percent_by_user @user, @percent

      expect(@published_course.read_percent_of_user(@user)).to eq 1
    end

    it "has_read_by_user?" do
      @percent = 100

      expect(@published_course.has_read_by_user?(@user)).to be false

      @published_course.published_wares.map do |p_ware|
        @ware = KcCourses::Ware.find p_ware['id']
        @ware.set_read_percent_by_user @user, @percent
      end

      expect(@published_course.has_read_by_user?(@user)).to be true
    end

    it "spent_time_of_user" do
      @published_ware = @published_course.published_wares.first
      @ware = KcCourses::Ware.find @published_ware['id']
      expect(@published_course.spent_time_of_user(@user)).to eq 0
      @ware.set_read_percent_by_user @user, 1
      expect(@published_course.spent_time_of_user(@user)).to eq 1
      sleep(2)
      @ware.set_read_percent_by_user @user, 50

      # 2秒？
      expect(@published_course.spent_time_of_user(@user)).to eq 2
    end

    it "last_studied_at_of_user" do
      @published_ware = @published_course.published_wares.first
      @ware = KcCourses::Ware.find @published_ware['id']
      expect(@published_course.last_studied_at_of_user(@user)).to be_nil
      @ware.set_read_percent_by_user @user, 1
      expect(@published_course.last_studied_at_of_user(@user) - Time.now).to be <= 5
    end

    describe "学习了一个课件" do
      before do
        @percent = 100
        @published_ware = @published_course.published_wares.first
        @ware = KcCourses::Ware.find @published_ware['id']
        @ware.set_read_percent_by_user @user, @percent
      end

      it "read_percent_of_user_before_day" do
        expect(@published_course.read_percent_of_user_before_day(@user, Time.now)).to eq (@percent / @wares.length.to_f).round

        expect(@published_course.read_percent_of_user_before_day(@user, 1.day.from_now)).to eq (@percent / @wares.length.to_f).round

        expect(@published_course.read_percent_of_user_before_day(@user, 1.day.ago)).to eq 0
      end

      it "read_percent_change_of_user" do
        expect(@published_course.read_percent_change_of_user(@user, Time.now)).to eq (@percent / @wares.length.to_f).round

        expect(@published_course.read_percent_change_of_user(@user, 1.day.from_now)).to eq 0

        expect(@published_course.read_percent_change_of_user(@user, 1.day.ago)).to eq 0
      end
    end

    describe "studing_ware_of_user" do
      it "未学习, 返回nil" do
        expect(@published_course.studing_ware_of_user(@user)).to be_nil
      end

      it "课件1，学习一部分, 返回课件1" do
        @published_ware = @published_course.published_wares.first
        @ware = KcCourses::Ware.find @published_ware['id']
        @ware.set_read_percent_by_user @user, 50

        expect(@published_course.studing_ware_of_user(@user)).to eq @ware
      end

      it "全学习了" do
        @published_course.published_wares do |published_ware|
          @ware = KcCourses::Ware.find published_ware['id']
          @ware.set_read_percent_by_user @user, 100
        end

        expect(@published_course.studing_ware_of_user(@user)).to be_nil
      end
    end
  end

  # TODO scope
    #it 'studing_of_user(user)  studied_of_user(user)' do
      #expect(KcCourses::Course.respond_to? :studing_of_user).to eq(true)
      #expect(KcCourses::Course.respond_to? :studied_of_user).to eq(true)
      #user = create(:user)

      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)
      #ware112 = create(:ware, :chapter => chapter11)

      #course2 = create(:course)
      #chapter21 = create(:chapter, :course => course2)
      #ware211 = create(:ware, :chapter => chapter21)

      #course3 = create(:course)
      #chapter31 = create(:chapter, :course => course3)
      #ware311 = create(:ware, :chapter => chapter31)

      #course4 = create(:course)
      #chapter41 = create(:chapter, :course => course4)
      #ware411 = create(:ware, :chapter => chapter41)

      #course5 = create(:course)
      #chapter51 = create(:chapter, :course => course5)
      #ware511 = create(:ware, :chapter => chapter51)
      ##课程一 已做完
      #ware111.set_read_percent_by_user(user, 100)
      ##课程二 完成了 60
      #ware211.set_read_percent_by_user(user, 60)
      ##课程三 已做完
      #ware311.set_read_percent_by_user(user, 100)
      ##课程四 完成了 25
      #ware411.set_read_percent_by_user(user, 0.1)
      ##课程五 没做过

      #expect(KcCourses::Course.studing_of_user(nil).class.name).to eq('Mongoid::Criteria')
      #expect(KcCourses::Course.studied_of_user(nil).class.name).to eq('Mongoid::Criteria')

      #expect(KcCourses::Course.studing_of_user(user).class.name).to eq('Mongoid::Criteria')
      #expect(KcCourses::Course.studied_of_user(user).class.name).to eq('Mongoid::Criteria')

      #expect(KcCourses::Course.studing_of_user(user).first).to eq(course1)
      #expect(KcCourses::Course.studied_of_user(user).last).to eq(course3)
      #expect(KcCourses::Course.studing_of_user(user).count).to eq(3)
      #expect(course4.read_percent_of_user(user)).to eq(1)
    #end

  #describe "@course.studing_ware_of_user(user)" do
    ##课程中没有课件
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)

      #expect(course1.studing_ware_of_user(user)).to eq(nil)
    #}
    ##没有学习记录
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)

      #expect(course1.studing_ware_of_user(user)).to eq(nil)
    #}
    ##存在课件有学习记录，也存在课件没有学习记录,最后的学习记录没有学习 100%
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)
      #ware112 = create(:ware, :chapter => chapter11)
      #ware111.set_read_percent_by_user(user, 50)

      #expect(course1.studing_ware_of_user(user)).to eq(ware111)
    #}
    ##存在课件有学习记录，也存在课件没有学习记录,最后的学习记录学习了 100%
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)
      #ware112 = create(:ware, :chapter => chapter11)
      #ware111.set_read_percent_by_user(user, 100)

      #expect(course1.studing_ware_of_user(user)).to eq(ware112)
    #}
    ##所有课件都有学习记录但最后一个课件的学习记录没有学习 100%
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)
      #ware112 = create(:ware, :chapter => chapter11)
      #ware111.set_read_percent_by_user(user, 100)
      #ware112.set_read_percent_by_user(user, 60)

      #expect(course1.studing_ware_of_user(user)).to eq(ware112)
    #}
    ##所有课件都有学习记录且所有的学习记录都是学习 100%
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)
      #ware112 = create(:ware, :chapter => chapter11)
      #ware111.set_read_percent_by_user(user, 100)
      #ware112.set_read_percent_by_user(user, 100)

      #expect(course1.studing_ware_of_user(user)).to eq(nil)
    #}
    ##最新学习记录是 100%，倒数第二个（或者N个）不是 100%（这个除非是学习后，课程被修改。应该返回未学习且安排序最考前的课件）
    #it{
      #user = create(:user)
      #course1 = create(:course)
      #chapter11 = create(:chapter, :course => course1)
      #ware111 = create(:ware, :chapter => chapter11)
      #ware113 = create(:ware, :chapter => chapter11)
      #ware111.set_read_percent_by_user(user, 100)
      #ware113.set_read_percent_by_user(user, 100)
      #ware112 = create(:ware, :chapter => chapter11)

      #expect(course1.studing_ware_of_user(user)).to eq(ware112)
    #}

    ##测试当课件学习进度值很小时，会否视对应课程为非正在学习课程
    #it{
      #user = create(:user)
      #course = create(:course)
      #chapter = create(:chapter, :course => course)
      #ware1 = create(:ware, :chapter => chapter)
      #ware2 = create(:ware, :chapter => chapter)
      #ware3 = create(:ware, :chapter => chapter)
      #ware4 = create(:ware, :chapter => chapter)
      #ware5 = create(:ware, :chapter => chapter)

      #ware5.set_read_percent_by_user(user, 1)

      #expect(course.read_percent_of_user(user)).to eq(1)

      #expect(KcCourses::Course.studing_of_user(user).count).to eq(1)
    #}
  #end


end
