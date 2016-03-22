require 'rails_helper'

RSpec.describe KcCourses::Course, type: :model do
  it { should validate_presence_of :title }
  it { should validate_presence_of :user }

  it "基础字段" do
    @course = create(:course)
    expect(@course.respond_to?(:title)).to be true
    expect(@course.respond_to?(:desc)).to be true
    expect(@course.respond_to?(:cover)).to be true

    expect(@course.respond_to?(:user_id)).to be true
    expect(@course.respond_to?(:file_entity_id)).to be true
    expect(@course.respond_to?(:file_entity)).to be true

    expect(@course.respond_to?(:course_subject_ids)).to be true
  end

  it "关系" do
    @course = create(:course)
    expect(@course.respond_to?(:user)).to be true
    expect(@course.respond_to?(:file_entity)).to be true
    expect(@course.respond_to?(:course_subjects)).to be true

    expect(@course.respond_to?(:published_courses)).to be true
  end

  describe "scopes" do
    it 'recent' do
      expect(KcCourses::Course.respond_to? :recent).to eq(true)
      @course = create(:course)
      expect(KcCourses::Course.recent.first).to eq(@course)
    end

    it 'studing_of_user(user)  studied_of_user(user)' do
      expect(KcCourses::Course.respond_to? :studing_of_user).to eq(true)
      expect(KcCourses::Course.respond_to? :studied_of_user).to eq(true)
      user = create(:user)

      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)

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
      ware411.set_read_percent_by_user(user, 0.1)
      #课程五 没做过

      expect(KcCourses::Course.studing_of_user(nil).class.name).to eq('Mongoid::Criteria')
      expect(KcCourses::Course.studied_of_user(nil).class.name).to eq('Mongoid::Criteria')

      expect(KcCourses::Course.studing_of_user(user).class.name).to eq('Mongoid::Criteria')
      expect(KcCourses::Course.studied_of_user(user).class.name).to eq('Mongoid::Criteria')

      expect(KcCourses::Course.studing_of_user(user).first).to eq(course1)
      expect(KcCourses::Course.studied_of_user(user).last).to eq(course3)
      expect(KcCourses::Course.studing_of_user(user).count).to eq(3)
      expect(course4.read_percent_of_user(user)).to eq(1)
    end
  end

  describe "methods" do
    it '#get_cover' do
      @course = create(:course)
      expect(@course.respond_to?(:get_cover)).to be true

      # 没有上传图片
      expect(@course.get_cover).to eq ENV['course_default_cover_url']

      qiniu_callback_body = {
        bucket: "fushang318",
        token: "/f/IuR0fINf.jpg",
        file_size: "25067",
        original: "1-120GQF34TY.jpg",
        mime: "image/jpeg",
        image_width: "200",
        image_height: "200",
        image_rgb: "0x4f4951"
      }
      @file_entity = FilePartUpload::FileEntity.from_qiniu_callback_body qiniu_callback_body

      @course.update_attribute :file_entity, @file_entity
      expect(@course.get_cover).to eq @file_entity.url
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
      ware113.set_read_percent_by_user(user, 100)
      ware112 = create(:ware, :chapter => chapter11)

      expect(course1.studing_ware_of_user(user)).to eq(ware112)
    }

    #测试当课件学习进度值很小时，会否视对应课程为非正在学习课程
    it{
      user = create(:user)
      course = create(:course)
      chapter = create(:chapter, :course => course)
      ware1 = create(:ware, :chapter => chapter)
      ware2 = create(:ware, :chapter => chapter)
      ware3 = create(:ware, :chapter => chapter)
      ware4 = create(:ware, :chapter => chapter)
      ware5 = create(:ware, :chapter => chapter)

      ware5.set_read_percent_by_user(user, 1)

      expect(course.read_percent_of_user(user)).to eq(1)

      expect(KcCourses::Course.studing_of_user(user).count).to eq(1)
    }
  end

  describe "@course.spent_time_of_user(user)" do
    before(:each){
      @day_1 = Time.local(2012, 12, 22, 10, 0, 0)
      @day_2 = Time.local(2012, 12, 23, 10, 0, 0)
      @day_3 = Time.local(2012, 12, 24, 10, 0, 0)
      @day_4 = Time.local(2012, 12, 25, 10, 0, 0)

      @user = create(:user)
      @course1 = create(:course)
      @chapter11 = create(:chapter, :course => @course1)
      @ware111 = create(:ware, :chapter => @chapter11)
      @ware112 = create(:ware, :chapter => @chapter11)
      @ware113 = create(:ware, :chapter => @chapter11)
    }

    #没有学习记录
    it{
      expect(@course1.spent_time_of_user(@user)).to eq(0)
    }
    #存在一个课件有学习记录,没有更新
    it{
      Timecop.freeze(@day_1) do
        @ware111.set_read_percent_by_user(@user, 20)
      end

      expect(@course1.spent_time_of_user(@user)).to eq(0) 
    }
    #存在一个课件有学习记录,有更新
    it{
      Timecop.freeze(@day_1) do
        @ware111.set_read_percent_by_user(@user, 20)
      end


      Timecop.freeze(@day_2) do
        @ware111.set_read_percent_by_user(@user, 100)
      end


      expect(@course1.spent_time_of_user(@user)).to eq(86400) 
    }
    #存在多个课件有学习记录，最后创建的学习记录没有更新
    it{
      Timecop.freeze(@day_1) do
        @ware111.set_read_percent_by_user(@user, 20)
      end

      Timecop.freeze(@day_2) do
        @ware111.set_read_percent_by_user(@user, 100)
      end

      Timecop.freeze(@day_3) do
        @ware112.set_read_percent_by_user(@user, 100)
      end

      expect(@course1.spent_time_of_user(@user)).to eq(172800) 
    }
    # #存在多个课件有学习记录，最后创建的学习记录有更新
    it{
      Timecop.freeze(@day_1) do
        @ware111.set_read_percent_by_user(@user, 100)
      end

      Timecop.freeze(@day_2) do
        @ware112.set_read_percent_by_user(@user, 30)
      end

      Timecop.freeze(@day_3) do
        @ware112.set_read_percent_by_user(@user, 100)
      end

      expect(@course1.spent_time_of_user(@user)).to eq(172800) 
    }
    #所有课件都有学习记录，最后创建的学习记录没有更新
    it{
      Timecop.freeze(@day_1) do
        @ware111.set_read_percent_by_user(@user, 100)
      end

      Timecop.freeze(@day_2) do
        @ware112.set_read_percent_by_user(@user, 30)
      end

      Timecop.freeze(@day_3) do
        @ware112.set_read_percent_by_user(@user, 100)
      end

      Timecop.freeze(@day_4) do
        @ware113.set_read_percent_by_user(@user, 100)
      end

      expect(@course1.spent_time_of_user(@user)).to eq(259200) 
    }
    #所有课件都有学习记录，最后创建的学习记录有更新
    it{
      Timecop.freeze(@day_1) do
        @ware111.set_read_percent_by_user(@user, 100)
      end

      Timecop.freeze(@day_2) do
        @ware112.set_read_percent_by_user(@user, 100)
      end

      Timecop.freeze(@day_3) do
        @ware113.set_read_percent_by_user(@user, 50)
      end

      Timecop.freeze(@day_4) do
        @ware113.set_read_percent_by_user(@user, 100)
      end

      expect(@course1.spent_time_of_user(@user)).to eq(259200) 
    }
  end

  describe "@course.last_studied_at_of_user(user)" do
    before(:each){
      @day_1 = Time.local(2012, 12, 22, 10, 0, 0)
      @day_2 = Time.local(2012, 12, 23, 10, 0, 0)
    }
    # user 为 nil
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware113 = create(:ware, :chapter => chapter11)

      Timecop.freeze(@day1) do
        ware111.set_read_percent_by_user(user, 100)
      end

      expect(course1.last_studied_at_of_user(nil)).to eq(nil)
    }
    # 没有学习记录
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware113 = create(:ware, :chapter => chapter11)

      expect(course1.last_studied_at_of_user(user)).to eq(nil)
    }
    # 有学习记录
    it{
      user = create(:user)
      course1 = create(:course)
      chapter11 = create(:chapter, :course => course1)
      ware111 = create(:ware, :chapter => chapter11)
      ware112 = create(:ware, :chapter => chapter11)
      ware113 = create(:ware, :chapter => chapter11)

      Timecop.freeze(@day_1) do
        ware111.set_read_percent_by_user(user, 100)
      end

      Timecop.freeze(@day_2) do
        ware112.set_read_percent_by_user(user, 100)
      end

      expect(course1.last_studied_at_of_user(user)).to eq(@day_2)
    }
  end
end
