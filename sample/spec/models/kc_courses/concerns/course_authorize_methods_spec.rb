require 'rails_helper'

RSpec.describe KcCourses::Concerns::CourseAuthorizeMethods, type: :module do
  describe KcCourses::Course, type: :model do
    before do
      @course = create(:course)
    end

    it "关系" do
      expect(@course.respond_to?(:user_course_authorizes)).to be true
    end

    describe "方法" do
      before do
        @user = create(:user)
      end

      it "#add_user_course_authorize" do
        expect(@course.respond_to?(:add_user_course_authorize)).to be true
        expect(@course.add_user_course_authorize(@user).class.name).to eq "Mongoid::Relations::Targets::Enumerable"
      end

      it "#user_course_authorized?" do
        expect(@course.respond_to?(:user_course_authorized?)).to be true

        expect(@course.user_course_authorized?(@user)).to be false
        @course.add_user_course_authorize(@user)
        expect(@course.user_course_authorized?(@user)).to be true
      end

      it "#add_user_course_authorizes" do
        expect(@course.respond_to?(:add_user_course_authorizes)).to be true

        # 未填加
        expect(@course.user_course_authorized?(@user)).to be false
        expect(@course.user_course_authorized?(@user1)).to be false

        @user1 = create(:user)
        expect(@course.add_user_course_authorizes([@user, @user1])).to be true

        expect(@course.user_course_authorized?(@user1)).to be true
        expect(@course.user_course_authorized?(@user)).to be true
      end

      it "#remove_user_course_authorize" do
        expect(@course.respond_to?(:remove_user_course_authorize)).to be true

        @course.add_user_course_authorize(@user)
        expect(@course.user_course_authorized?(@user)).to be true
        expect(@course.user_course_authorized?(@user)).to be true

        expect(@course.remove_user_course_authorize(@user)).to eq @user.user_course_authorize
        expect(@course.user_course_authorized?(@user)).to be false
      end

      it "#remove_user_course_authorizes" do
        expect(@course.respond_to?(:remove_user_course_authorizes)).to be true

        @user1 = create(:user)
        expect(@course.add_user_course_authorizes([@user, @user1])).to be true
        expect(@course.user_course_authorized?(@user1)).to be true
        expect(@course.user_course_authorized?(@user)).to be true

        expect(@course.remove_user_course_authorizes([@user, @user1])).to be true
        expect(@course.user_course_authorized?(@user1)).to be false
        expect(@course.user_course_authorized?(@user)).to be false
      end

      it "#authorized_users" do
        expect(@course.respond_to?(:authorized_users)).to be true

        @user1 = create(:user)
        expect(@course.add_user_course_authorizes([@user, @user1])).to be true

        @course.reload
        expect(@course.authorized_users.to_a).to include(@user)
        expect(@course.authorized_users.to_a).to include(@user1)
      end
    end
  end
end
