require 'rails_helper'

RSpec.describe KcCourses::Concerns::Authorizeable, type: :module do
  describe KcCourses::TeachingActivity do
    it "关系" do
      @teaching_activity = create(:teaching_activity)
      expect(@teaching_activity.respond_to?(:authorizes)).to be true
    end

    describe "方法" do
      before do
        @user = create(:user)
        @teaching_activity = create(:teaching_activity)
        @value = "test"
      end

      it "set_authorize" do
        expect(@teaching_activity.set_authorize(@user, @value)).to_not be false
        expect(@teaching_activity.set_authorize(@user, "test1")).to be true
      end

      it "authorized?" do
        expect(@teaching_activity.authorized?(@user)).to be false
        @teaching_activity.set_authorize(@user, @value)
        expect(@teaching_activity.authorized?(@user)).to be true
      end

      it "authorized_with?" do
        expect(@teaching_activity.authorized?(@user)).to be false
        @teaching_activity.set_authorize(@user, @value)
        expect(@teaching_activity.authorized_with?(@user, @value)).to be true
      end

      it "get_authorize" do
        @value1 = "test1"
        @teaching_activity.set_authorize(@user, @value)
        @authorize = @teaching_activity.get_authorize(@user)
        expect(@authorize).to_not be_nil
        expect(@authorize.value).to eq @value

        # 重设
        @teaching_activity.set_authorize(@user, @value1)
        @authorize.reload
        expect(@authorize.value).to eq @value1
      end

      it "authorize_users" do
        @user1 = create(:user)
        expect(@teaching_activity.authorize_users.any?).to be false

        @teaching_activity.set_authorize(@user, @value)
        expect(@teaching_activity.authorize_users.count).to eq 1

        @teaching_activity.set_authorize(@user1, @value)
        expect(@teaching_activity.authorize_users.count).to eq 2
      end

      it "authorize_user_ids_with" do
        @user1 = create(:user)

        expect(@teaching_activity.authorize_user_ids_with(@value).any?).to be false

        @teaching_activity.set_authorize(@user, @value)
        expect(@teaching_activity.authorize_user_ids_with(@value).any?).to be true
        expect(@teaching_activity.authorize_user_ids_with(@value)).to eq [@user.id]

        @teaching_activity.set_authorize(@user1, @value)
        expect(@teaching_activity.authorize_user_ids_with(@value)).to eq [@user.id, @user1.id]

        @teaching_activity.set_authorize(@user1, "test1")
        expect(@teaching_activity.authorize_user_ids_with(@value)).to eq [@user.id]
      end

      it "authorize_users_with" do
        @user1 = create(:user)

        expect(@teaching_activity.authorize_users_with(@value).any?).to be false

        @teaching_activity.set_authorize(@user, @value)
        expect(@teaching_activity.authorize_users_with(@value).any?).to be true
        expect(@teaching_activity.authorize_users_with(@value).length).to eq 1

        @teaching_activity.set_authorize(@user1, @value)
        expect(@teaching_activity.authorize_users_with(@value).length).to eq 2

        @teaching_activity.set_authorize(@user1, "test1")
        expect(@teaching_activity.authorize_users_with(@value).length).to eq 1
      end
    end
  end
end
