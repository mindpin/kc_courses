require 'rails_helper'

RSpec.describe KcCourses::Concerns::UserAuthorizeMethods, type: :module do
  #class User
    #include KcCourses::Concerns::UserAuthorizeMethods
  #end

  describe User, type: :model do
    before do
      @user = create(:user)
    end

    it "关系" do
      @user = create(:user)
      expect(@user.respond_to?(:user_course_authorize)).to be true
    end

    describe "方法" do
      it "#authorized_courses" do
        expect(@user.respond_to?(:authorized_courses)).to be true

        @course1 = create(:course)
        @course2 = create(:course)
        expect(@user.authorized_courses).to be_blank

        @course1.add_user_course_authorize(@user)
        expect(@user.authorized_courses).to include(@course1)

        @user.reload
        @course2.add_user_course_authorize(@user)
        @user.reload
        expect(@user.authorized_courses).to include(@course2)
        expect(@user.authorized_courses).to include(@course1)
      end
    end
  end
end
