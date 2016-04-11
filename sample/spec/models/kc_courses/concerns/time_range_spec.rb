require 'rails_helper'

class TimeRangeTestClass
  include Mongoid::Document
  include KcCourses::Concerns::TimeRange
end

RSpec.describe TimeRangeTestClass, type: :model do
  it "属性" do
    @obj = TimeRangeTestClass.create
    expect(@obj.respond_to?(:started_at)).to be true
    expect(@obj.respond_to?(:ended_at)).to be true
  end

  describe "方法" do
    it "started?" do
      expect(TimeRangeTestClass.create(started_at: nil).started?).to be true
      expect(TimeRangeTestClass.create(started_at: 1.day.ago).started?).to be true
      expect(TimeRangeTestClass.create(started_at: Time.now).started?).to be true

      expect(TimeRangeTestClass.create(started_at: 1.day.from_now).started?).to be false
    end

    it "ended?" do
      expect(TimeRangeTestClass.create(ended_at: nil).ended?).to be false
      expect(TimeRangeTestClass.create(ended_at: 1.day.from_now).ended?).to be false

      expect(TimeRangeTestClass.create(ended_at: 1.day.ago).ended?).to be true
      expect(TimeRangeTestClass.create(ended_at: Time.now).ended?).to be true
    end

    it "running?" do
      expect(TimeRangeTestClass.create(started_at: nil, ended_at: nil).running?).to be true
      expect(TimeRangeTestClass.create(started_at: 1.day.ago, ended_at: nil).running?).to be true
      expect(TimeRangeTestClass.create(started_at: Time.now, ended_at: nil).running?).to be true
      expect(TimeRangeTestClass.create(started_at: 1.day.from_now, ended_at: nil).running?).to be false

      expect(TimeRangeTestClass.create(started_at: nil, ended_at: 1.day.ago).running?).to be false
      expect(TimeRangeTestClass.create(started_at: nil, ended_at: Time.now).running?).to be false
      expect(TimeRangeTestClass.create(started_at: nil, ended_at: 1.day.from_now).running?).to be true

      expect(TimeRangeTestClass.create(started_at: 1.day.ago, ended_at: 1.day.from_now).running?).to be true
      expect(TimeRangeTestClass.create(started_at: 1.day.ago, ended_at: 1.day.ago).running?).to be false
      expect(TimeRangeTestClass.create(started_at: 1.day.from_now, ended_at: 1.day.from_now).running?).to be false

      expect(TimeRangeTestClass.create(started_at: 1.day.from_now, ended_at: 1.day.ago).running?).to be false
    end


  end
end

