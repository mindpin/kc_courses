require 'rails_helper'

RSpec.describe KcCourses::CourseSubject, type: :model do
  it "attributes" do
    @course_subject = create(:course_subject)
    expect(@course_subject.respond_to?(:name)).to eq true
  end

  it "relationships" do
    @course_subject = create(:course_subject)
    expect(@course_subject.respond_to?(:courses)).to eq true
  end

  it 'validates' do
    expect(build(:course_subject, name: nil)).not_to be_valid
    #expect(build(:course_subject, courses: [])).not_to be_valid
  end

  it 'courses course_subjects' do
    @course_subject = create(:course_subject)
    @course = @course_subject.courses.first
    expect(@course.course_subjects.count).to eq 1
  end
end
