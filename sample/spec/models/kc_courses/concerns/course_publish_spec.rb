require 'rails_helper'

RSpec.describe KcCourses::Concerns::CoursePublish, type: :module do
  describe KcCourses::Course, type: :model do
    before do
      @course = create(:course)
    end

    it '关系' do
      expect(@course.respond_to? :published_courses).to eq(true)
    end

    it '方法' do
      expect(@course.respond_to? :publish!).to eq(true)
      expect(@course.respond_to? :unpublish!).to eq(true)
    end

    it "#publish!" do
      @course.publish!
      expect(@course.published_courses.count).to eq 1
      expect(@course.published_courses.enabled.count).to eq 1

      @published_course = @course.published_courses.enabled.first

      # FIXME 此判断，时间会被系统处理为UTC
      #expect(@published_course.data).to eq(@course.get_publish_data)
    end

    it "#unpublish!" do
      @course.publish!
      @course.unpublish!

      expect(@course.published_courses.count).to eq 1
      expect(@course.published_courses.enabled.count).to eq 0
    end
  end
end
