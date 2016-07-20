require 'rails_helper'

RSpec.describe KcCourses::TeachingExamRecord, type: :model do
  it { is_expected.to validate_presence_of :score }
  it { is_expected.to validate_presence_of :max_score }

  it "属性" do
    @teaching_exam_record = create(:teaching_exam_record)
    expect(@teaching_exam_record.respond_to?(:score)).to be true
    expect(@teaching_exam_record.respond_to?(:max_score)).to be true
    expect(@teaching_exam_record.respond_to?(:examiner_name)).to be true
    expect(@teaching_exam_record.respond_to?(:desc)).to be true
    expect(@teaching_exam_record.respond_to?(:submitted_at)).to be true

    expect(@teaching_exam_record.respond_to?(:exam_id)).to be true
    expect(@teaching_exam_record.respond_to?(:user_id)).to be true
  end

  it "关系" do
    @teaching_exam_record = create(:teaching_exam_record)
    expect(@teaching_exam_record.respond_to?(:exam)).to be true
    expect(@teaching_exam_record.respond_to?(:user)).to be true
  end

  describe "方法" do
  end
end
