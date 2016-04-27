require 'rails_helper'

RSpec.describe KcCourses::Concerns::UserActivityMethods, type: :module do
  before do
    @user = create(:user)
  end

  it "关系" do
    expect(@user.respond_to?(:activity_managers)).to be true
    expect(@user.respond_to?(:activity_members)).to be true
  end

  describe "方法" do
    it "joined_activities" do
      @teaching_activity = create(:teaching_activity)

      expect(@user.joined_activities.length).to eq 0
      @teaching_activity.add_member(@user)

      expect(@user.joined_activities.length).to eq 1
      expect(@user.joined_activities.first.class.name).to eq "KcCourses::TeachingActivity"
    end

    it "manage_activities" do
      @teaching_activity = create(:teaching_activity)

      expect(@user.manage_activities.length).to eq 0
      @teaching_activity.add_manager(@user)

      expect(@user.manage_activities.length).to eq 1
      expect(@user.manage_activities.first.class.name).to eq "KcCourses::TeachingActivity"
    end
  end
end

