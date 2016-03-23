require 'rails_helper'

RSpec.describe KcCourses::PublishedCourse, type: :model do
  before do
    @published_course = create(:published_course)
  end

  it { should validate_presence_of :course }

  it '基础字段' do
    expect(@published_course.respond_to?(:enabled)).to be true
    expect(@published_course.respond_to?(:data)).to be true
    expect(@published_course.respond_to?(:course_id)).to be true

    # 默认
    expect(@published_course.enabled).to be false
  end

  describe "关系" do
    it 'course' do
      expect(@published_course.respond_to?(:course)).to be true
      expect(@published_course.course.class.name).to eq 'KcCourses::Course'

      # 验证
      expect(build(:published_course, course:nil)).to_not be_valid
    end

    it "published_course_snapshots" do
      expect(@published_course.respond_to?(:published_course_snapshots)).to be true
    end
  end
end
