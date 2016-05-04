require 'rails_helper'

RSpec.describe KcCourses::TeachingExam, type: :model do
  it { should validate_presence_of :teaching_group }

  it "属性" do
    @teaching_exam = create(:teaching_exam)
    expect(@teaching_exam.respond_to?(:name)).to be true
    expect(@teaching_exam.respond_to?(:desc)).to be true

    expect(@teaching_exam.respond_to?(:started_at)).to be true
    expect(@teaching_exam.respond_to?(:ended_at)).to be true

    expect(@teaching_exam.respond_to?(:teaching_group_id)).to be true

    expect(@teaching_exam.kind).to eq "online"
  end

  it "关系" do
    @teaching_exam = create(:teaching_exam)
    expect(@teaching_exam.respond_to?(:teaching_group)).to be true
    expect(@teaching_exam.respond_to?(:teaching_lesson)).to be true
  end

  describe "方法" do
    it "state" do
      expect(create(:teaching_exam, started_at: 2.day.ago, ended_at: 1.day.ago).state).to eq "已结束"
      expect(create(:teaching_exam, started_at: 2.day.ago, ended_at: 1.day.from_now).state).to eq "已开考"
      expect(create(:teaching_exam, started_at: 2.day.from_now, ended_at: 3.day.from_now).state).to eq "未开始"
    end
  end
end

