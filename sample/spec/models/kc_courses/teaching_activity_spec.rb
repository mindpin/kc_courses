require 'rails_helper'

RSpec.describe KcCourses::TeachingActivity, type: :model do
  it { should validate_presence_of :name }

  it "属性" do
    @teaching_activity = create(:teaching_activity)
    expect(@teaching_activity.respond_to?(:name)).to be true
    expect(@teaching_activity.respond_to?(:desc)).to be true
    expect(@teaching_activity.respond_to?(:started_at)).to be true
    expect(@teaching_activity.respond_to?(:ended_at)).to be true
    expect(@teaching_activity.respond_to?(:apply_started_at)).to be true
    expect(@teaching_activity.respond_to?(:apply_ended_at)).to be true

    expect(@teaching_activity.respond_to?(:manager_id)).to be true
  end

  it "关系" do
    @teaching_activity = create(:teaching_activity)
    expect(@teaching_activity.respond_to?(:manager)).to be true

    expect(@teaching_activity.respond_to?(:events)).to be true
  end

  describe "方法" do
    it "started?" do
      expect(create(:teaching_activity, started_at: nil).started?).to be true
      expect(create(:teaching_activity, started_at: 1.day.ago).started?).to be true
      expect(create(:teaching_activity, started_at: Time.now).started?).to be true

      expect(create(:teaching_activity, started_at: 1.day.from_now).started?).to be false
    end

    it "ended?" do
      expect(create(:teaching_activity, ended_at: nil).ended?).to be false
      expect(create(:teaching_activity, ended_at: 1.day.from_now).ended?).to be false

      expect(create(:teaching_activity, ended_at: 1.day.ago).ended?).to be true
      expect(create(:teaching_activity, ended_at: Time.now).ended?).to be true
    end

    it "running?" do
      expect(create(:teaching_activity, started_at: nil, ended_at: nil).running?).to be true
      expect(create(:teaching_activity, started_at: 1.day.ago, ended_at: nil).running?).to be true
      expect(create(:teaching_activity, started_at: Time.now, ended_at: nil).running?).to be true
      expect(create(:teaching_activity, started_at: 1.day.from_now, ended_at: nil).running?).to be false

      expect(create(:teaching_activity, started_at: nil, ended_at: 1.day.ago).running?).to be false
      expect(create(:teaching_activity, started_at: nil, ended_at: Time.now).running?).to be false
      expect(create(:teaching_activity, started_at: nil, ended_at: 1.day.from_now).running?).to be true

      expect(create(:teaching_activity, started_at: 1.day.ago, ended_at: 1.day.from_now).running?).to be true
      expect(create(:teaching_activity, started_at: 1.day.ago, ended_at: 1.day.ago).running?).to be false
      expect(create(:teaching_activity, started_at: 1.day.from_now, ended_at: 1.day.from_now).running?).to be false

      expect(create(:teaching_activity, started_at: 1.day.from_now, ended_at: 1.day.ago).running?).to be false
    end

    it "apply_started?" do
      expect(create(:teaching_activity, apply_started_at: nil).apply_started?).to be true
      expect(create(:teaching_activity, apply_started_at: 1.day.ago).apply_started?).to be true
      expect(create(:teaching_activity, apply_started_at: Time.now).apply_started?).to be true

      expect(create(:teaching_activity, apply_started_at: 1.day.from_now).apply_started?).to be false
    end

    it "apply_ended?" do
      expect(create(:teaching_activity, apply_ended_at: nil).apply_ended?).to be false
      expect(create(:teaching_activity, apply_ended_at: 1.day.from_now).apply_ended?).to be false

      expect(create(:teaching_activity, apply_ended_at: 1.day.ago).apply_ended?).to be true
      expect(create(:teaching_activity, apply_ended_at: Time.now).apply_ended?).to be true
    end

    it "could_apply?" do
      expect(create(:teaching_activity, apply_started_at: nil, apply_ended_at: nil).could_apply?).to be true
      expect(create(:teaching_activity, apply_started_at: 1.day.ago, apply_ended_at: nil).could_apply?).to be true
      expect(create(:teaching_activity, apply_started_at: Time.now, apply_ended_at: nil).could_apply?).to be true
      expect(create(:teaching_activity, apply_started_at: 1.day.from_now, apply_ended_at: nil).could_apply?).to be false

      expect(create(:teaching_activity, apply_started_at: nil, apply_ended_at: 1.day.ago).could_apply?).to be false
      expect(create(:teaching_activity, apply_started_at: nil, apply_ended_at: Time.now).could_apply?).to be false
      expect(create(:teaching_activity, apply_started_at: nil, apply_ended_at: 1.day.from_now).could_apply?).to be true

      expect(create(:teaching_activity, apply_started_at: 1.day.ago, apply_ended_at: 1.day.from_now).could_apply?).to be true
      expect(create(:teaching_activity, apply_started_at: 1.day.ago, apply_ended_at: 1.day.ago).could_apply?).to be false
      expect(create(:teaching_activity, apply_started_at: 1.day.from_now, apply_ended_at: 1.day.from_now).could_apply?).to be false

      expect(create(:teaching_activity, apply_started_at: 1.day.from_now, apply_ended_at: 1.day.ago).could_apply?).to be false
    end
  end
end
