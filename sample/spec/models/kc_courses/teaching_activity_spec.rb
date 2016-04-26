require 'rails_helper'

RSpec.describe KcCourses::TeachingActivity, type: :model do
  it { should validate_presence_of :name }

  it "属性" do
    @teaching_activity = create(:teaching_activity)
    expect(@teaching_activity.respond_to?(:name)).to be true
    expect(@teaching_activity.respond_to?(:desc)).to be true

    expect(@teaching_activity.respond_to?(:creator_id)).to be true
  end

  it "关系" do
    @teaching_activity = create(:teaching_activity)
    expect(@teaching_activity.respond_to?(:creator)).to be true

    expect(@teaching_activity.respond_to?(:events)).to be true
    expect(@teaching_activity.respond_to?(:lessons)).to be true

    expect(@teaching_activity.respond_to?(:activity_managers)).to be true
    expect(@teaching_activity.respond_to?(:activity_members)).to be true
  end

  describe "方法" do
    describe "负责人" do
      it "has_manager?" do
        @teaching_activity = create(:teaching_activity)
        @manager = create(:user)
        expect(@teaching_activity.has_manager?(@manager)).to be false

        @teaching_activity.activity_managers.create user: @manager
        expect(@teaching_activity.has_manager?(@manager)).to be true
      end

      it "add_manager" do
        @teaching_activity = create(:teaching_activity)
        @manager = create(:user)
        expect(@teaching_activity.has_manager?(@manager)).to be false

        expect(@teaching_activity.add_manager(@manager)).to_not be_nil
        expect(@teaching_activity.has_manager?(@manager)).to be true
      end

      it "managers" do
        @teaching_activity = create(:teaching_activity)
        @managers = []
        @managers.push create(:user)
        @managers.push create(:user)

        @managers.each do |manager|
          @teaching_activity.add_manager manager
        end

        expect(@teaching_activity.managers.to_a.sort).to eq @managers.sort
      end
    end

    describe "参与者" do
      it "has_member?" do
        @teaching_activity = create(:teaching_activity)
        @user = create(:user)
        expect(@teaching_activity.has_member?(@user)).to be false

        @teaching_activity.activity_members.create user: @user
        expect(@teaching_activity.has_member?(@user)).to be true
      end

      it "add_member" do
        @teaching_activity = create(:teaching_activity)
        @user = create(:user)
        expect(@teaching_activity.has_member?(@user)).to be false

        expect(@teaching_activity.add_member(@user)).to_not be_nil
        expect(@teaching_activity.has_member?(@user)).to be true
      end

      it "members" do
        @teaching_activity = create(:teaching_activity)
        @members = []
        @members.push create(:user)
        @members.push create(:user)

        @members.each do |user|
          @teaching_activity.add_member user
        end

        expect(@teaching_activity.members.to_a.sort).to eq @members.sort
      end
    end
  end
end
