require 'rails_helper'

RSpec.describe KcCourses::PublishedCourseSnapshot, type: :model do
  it { should validate_presence_of :course }
  it { should validate_presence_of :published_course }

  it '基础字段' do
    @published_course_snapshot = create(:published_course_snapshot)
    #expect(@published_course_snapshot.respond_to?(:enabled)).to be true
    expect(@published_course_snapshot.respond_to?(:data)).to be true
    expect(@published_course_snapshot.respond_to?(:course_id)).to be true
    expect(@published_course_snapshot.respond_to?(:published_course_id)).to be true

    # 默认
    #expect(@published_course_snapshot.enabled).to be false
  end

  describe "关系" do
    before do
      @published_course_snapshot = create(:published_course_snapshot)
    end

    it 'course' do
      expect(@published_course_snapshot.respond_to?(:course)).to be true
      expect(@published_course_snapshot.course.class.name).to eq 'KcCourses::Course'

      expect(@published_course_snapshot.respond_to?(:published_course)).to be true
      expect(@published_course_snapshot.published_course.class.name).to eq 'KcCourses::PublishedCourse'

      # 验证
      expect(build(:published_course_snapshot, course:nil)).to_not be_valid
      expect(build(:published_course_snapshot, published_course:nil)).to_not be_valid
    end
  end
end
