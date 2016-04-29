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

    #it "spent_time_of_user" do
      #@published_ware = @published_course.published_wares.first
      #@ware = KcCourses::Ware.find @published_ware['id']
      #expect(@published_course.spent_time_of_user(@user)).to eq 0
      #@ware.set_read_percent_by_user @user, 1
      #expect(@published_course.spent_time_of_user(@user)).to eq 1
      #sleep(2)
      #@ware.set_read_percent_by_user @user, 50

      ## 2秒？
      #expect(@published_course.spent_time_of_user(@user)).to eq 2
    #end

    it "spent_time_of_user" do
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
end
