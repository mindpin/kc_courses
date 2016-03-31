require 'rails_helper'

RSpec.describe KcCourses::CourseSubject, type: :model do
  it "attributes" do
    @course_subject = create(:course_subject)
    expect(@course_subject.respond_to?(:name)).to eq true
    expect(@course_subject.respond_to?(:slug)).to eq true
    expect(@course_subject.slug).to_not be_blank
  end

  it "relationships" do
    @course_subject = create(:course_subject)
    expect(@course_subject.respond_to?(:courses)).to eq true
  end

  it 'validates' do
    expect(build(:course_subject, name: nil)).not_to be_valid
    #expect(build(:course_subject, courses: [])).not_to be_valid
  end

  describe "删除课程分类时，不会级联对关联课程模型进行写操作，并且在读取这些课程的课程分类时，会忽略脏数据" do
    it{
      cs = KcCourses::CourseSubject.create(name: "课程分类一")
      course = create(:course)
      course.add_subject cs

      expect(KcCourses::CourseSubject.find(cs.id).course_ids.map(&:to_s)).to eq([course.id.to_s])
      expect(KcCourses::Course.find(course.id).course_subject_ids.map(&:to_s)).to eq([cs.id.to_s])

      KcCourses::CourseSubject.find(cs.id).destroy
      expect(KcCourses::Course.find(course.id).course_subject_ids.map(&:to_s)).to eq([cs.id.to_s])
      expect(KcCourses::Course.find(course.id).course_subjects).to eq([])
    }
  end
end
