require 'rails_helper'

RSpec.describe KcCourses::Concerns::CoursePublish, type: :module do
  describe KcCourses::Course, type: :model do
    before do
      @course = create(:course)
    end

    it '关系' do
      expect(@course.respond_to? :published_course).to eq(true)
      expect(@course.respond_to? :published_course_snapshots).to eq(true)
    end

    it '方法' do
      expect(@course.respond_to? :publish!).to eq(true)
      expect(@course.respond_to? :unpublish!).to eq(true)
    end

    it "#publish!" do
      expect(@course.published_course).to be_nil
      @course.publish!
      expect(@course.published_course).to_not be_nil
      expect(@course.published_course_snapshots.count).to eq 1
      expect(KcCourses::PublishedCourse.count).to eq 1
      expect(KcCourses::PublishedCourse.enabled.count).to eq 1

      # 第二次发布
      @course.publish!
      expect(@course.published_course).to_not be_nil
      expect(@course.published_course_snapshots.count).to eq 2
      expect(KcCourses::PublishedCourse.count).to eq 1
      expect(KcCourses::PublishedCourse.enabled.count).to eq 1
    end

    it "#unpublish!" do
      @course.publish!
      @course.unpublish!

      expect(@course.published_course).to_not be_nil
      expect(@course.published_course.enabled).to eq false
      expect(KcCourses::PublishedCourse.count).to eq 1
      expect(KcCourses::PublishedCourse.enabled.count).to eq 0

      # 第二次发布
      @course.publish!
      expect(@course.published_course).to_not be_nil
      expect(@course.published_course_snapshots.count).to eq 2
      expect(KcCourses::PublishedCourse.count).to eq 1
      expect(KcCourses::PublishedCourse.enabled.count).to eq 1

      # 第二次取消发布
      @course.unpublish!
      expect(@course.published_course).to_not be_nil
      expect(@course.published_course_snapshots.count).to eq 2
      expect(KcCourses::PublishedCourse.count).to eq 1
      expect(KcCourses::PublishedCourse.enabled.count).to eq 0
    end
  end
end
