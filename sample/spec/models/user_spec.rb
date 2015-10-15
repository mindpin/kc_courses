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
      expect(@user.course_joins.count).to eq(1)
      expect(@user.join_course(@course)).to be_nil
    end

    it '#cancel_join_course' do
      expect(@user.cancel_join_course(@course)).to eq(false)
      @user.join_course(@course)
      expect(@user.course_joins.count).to eq(1)
      expect(@user.cancel_join_course(@course)).to eq(true)
      expect(@user.course_joins.count).to eq(0)
    end


    describe "#join_courses" do
      before do
        @user.join_course(@course)
        @user.reload
      end

      it 'join_courses should has one' do
        expect(@user.join_courses.count).to eq(1)
        expect(@user.join_courses).to include(@course)
      end

      it 'kaminari' do
        expect(
          @user.join_courses do |b|
            b.page(1).per(5)
          end
        ).to include(@course)
      end
    end
  end
end
