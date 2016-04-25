require 'rails_helper'

RSpec.describe KcCourses::TeachingActivity, type: :model do
  it { should validate_presence_of :name }

  it "属性" do
    @teaching_activity = create(:teaching_activity)
    expect(@teaching_activity.respond_to?(:name)).to be true
    expect(@teaching_activity.respond_to?(:desc)).to be true

    expect(@teaching_activity.respond_to?(:manager_id)).to be true
  end

  it "关系" do
    @teaching_activity = create(:teaching_activity)
    expect(@teaching_activity.respond_to?(:manager)).to be true

    expect(@teaching_activity.respond_to?(:events)).to be true
    expect(@teaching_activity.respond_to?(:lessons)).to be true
  end

  describe "方法" do
  end
end
