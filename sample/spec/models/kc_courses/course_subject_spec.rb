require 'rails_helper'

RSpec.describe KcCourses::CourseSubject, type: :model do
  it "attributes" do
    @course_subject = create(:course_subject)
    expect(@course_subject.respond_to?(:name)).to eq true
    expect(@course_subject.respond_to?(:show_in_nav)).to eq true
    expect(@course_subject.respond_to?(:show_in_subnav)).to eq true
  end

  it "default" do
    @course_subject = create(:course_subject)
    expect(@course_subject.show_in_nav).to eq false
    expect(@course_subject.show_in_subnav).to eq false
  end

  it "relationships" do
    @course_subject = create(:course_subject)
    expect(@course_subject.respond_to?(:courses)).to eq true
  end

  it 'validates' do
    expect(build(:course_subject, name: nil)).not_to be_valid
    expect(build(:course_subject, courses: [])).not_to be_valid
  end
end
