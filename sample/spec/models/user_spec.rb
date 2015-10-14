require 'rails_helper'

RSpec.describe User, type: :model do
  describe "举例" do
    it{
      expect(create(:user).name).to match(/user\d+/)
    }
  end

  describe "join_course" do
    before do
      @user = create(:user)
      @course = create(:course)
    end

    it '#join_course' do
      expect(@user.join_course(nil)).to be_nil
      expect(@user.join_course('')).to be_nil
      expect(@user.join_course(@course)).not_to be_nil
      expect(@user.join_courses.count).to eq(1)
      expect(@user.join_course(@course)).to be_nil
    end

    it '#cancel_join_course' do
      expect(@user.cancel_join_course(@course)).to eq(false)
      @user.join_course(@course)
      expect(@user.join_courses.count).to eq(1)
      expect(@user.cancel_join_course(@course)).to eq(true)
      expect(@user.join_courses.count).to eq(0)
    end
  end
end
