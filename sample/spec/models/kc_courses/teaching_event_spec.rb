require 'rails_helper'

RSpec.describe KcCourses::TeachingEvent, type: :model do
  it "属性" do
    @teaching_event = create(:teaching_event)
    expect(@teaching_event.respond_to?(:desc)).to be true
    expect(@teaching_event.respond_to?(:learn_week)).to be true

    expect(@teaching_event.respond_to?(:activity_id)).to be true
    expect(@teaching_event.respond_to?(:course_id)).to be true

    expect(@teaching_event.learn_week).to be 0
  end

  it "关系" do
    @teaching_event = create(:teaching_event)
    expect(@teaching_event.respond_to?(:activity)).to be true
    expect(@teaching_event.respond_to?(:course)).to be true
  end

  describe "方法" do
  end
end

