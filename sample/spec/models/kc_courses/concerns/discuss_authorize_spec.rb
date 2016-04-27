require 'rails_helper'

RSpec.describe KcCourses::Concerns::DiscussAuthorize, type: :module do
  describe KcCourses::TeachingActivity, type: :model do
    #before do
      #@teaching_activity = create(:teaching_activity)
    #end

    #describe "relationships" do
      #it "#authorized_members" do
        #expect(@teaching_activity.respond_to?(:authorized_members)).to be true
      #end
    #end

    describe "方法" do
      before do
        @user = create(:user)
      end

      it "add_ban_member" do
        @teaching_activity = create(:teaching_activity)
        expect(@teaching_activity.add_ban_member(@user)).to be true
        expect(@teaching_activity.authorized_with?(@user, 'teaching_activity_ban')).to be true
      end

      it "add_view_member" do
        @teaching_activity = create(:teaching_activity)
        expect(@teaching_activity.add_view_member(@user)).to be true
        expect(@teaching_activity.authorized_with?(@user, 'teaching_activity_view')).to be true
      end


      it "add_full_member" do
        @teaching_activity = create(:teaching_activity)
        expect(@teaching_activity.add_full_member(@user)).to be true
        expect(@teaching_activity.authorized_with?(@user, 'teaching_activity_full')).to be true
      end

      describe "could_view_by?" do
        describe "分组设置所有人可浏览" do
          before do
            @teaching_activity = create(:teaching_activity, all_could_view: true)
          end

          it "正常可读" do
            expect(@teaching_activity.could_view_by?(@user)).to be true
          end

          it "屏蔽用户不可读" do
            @teaching_activity.add_ban_member(@user)
            expect(@teaching_activity.could_view_by?(@user)).to be false
          end
        end

        describe "分组设置非所有人可浏览" do
          before do
            @teaching_activity = create(:teaching_activity, all_could_view: false)
          end

          it "成员可读" do
            expect(@teaching_activity.could_view_by?(@user)).to be false
            @teaching_activity.add_member(@user)
            expect(@teaching_activity.could_view_by?(@user)).to be true
          end

          it "授权可读者可读" do
            expect(@teaching_activity.could_view_by?(@user)).to be false
            @teaching_activity.add_view_member(@user)
            expect(@teaching_activity.could_view_by?(@user)).to be true
          end

          it "全权授权者可读" do
            expect(@teaching_activity.could_view_by?(@user)).to be false
            @teaching_activity.add_full_member(@user)
            expect(@teaching_activity.could_view_by?(@user)).to be true
          end

          it "会员被屏蔽用户不可读" do
            @teaching_activity.add_member(@user)
            @teaching_activity.add_ban_member(@user)
            expect(@teaching_activity.could_view_by?(@user)).to be false
          end
        end
      end

      describe "could_post_by?" do
        describe "分组设置所有人可发帖" do
          before do
            @teaching_activity = create(:teaching_activity, all_could_post: true)
          end

          it "正常可发布" do
            expect(@teaching_activity.could_post_by?(@user)).to be true
          end

          it "屏蔽用户不可发布" do
            @teaching_activity.add_ban_member(@user)
            expect(@teaching_activity.could_view_by?(@user)).to be false
          end

          it "只能看帖用户不可发布" do
            @teaching_activity.add_view_member(@user)
            expect(@teaching_activity.could_post_by?(@user)).to be false
          end
        end

        describe "分组设置组员可发布" do
          before do
            @teaching_activity = create(:teaching_activity, all_could_post: false)
          end

          it "非组员不可发布" do
            expect(@teaching_activity.could_post_by?(@user)).to be false
          end

          it "成员可发布" do
            @teaching_activity.add_member(@user)
            expect(@teaching_activity.could_post_by?(@user)).to be true
          end

          it "可读者不可发布" do
            @teaching_activity.add_view_member(@user)
            expect(@teaching_activity.could_post_by?(@user)).to be false
          end

          it "全权授权者发布" do
            @teaching_activity.add_full_member(@user)
            expect(@teaching_activity.could_post_by?(@user)).to be true
          end

          it "会员被屏蔽用户不可读" do
            @teaching_activity.add_member(@user)
            @teaching_activity.add_ban_member(@user)
            expect(@teaching_activity.could_post_by?(@user)).to be false
          end
        end
      end

      #it '#authorized?' do
        #expect(@teaching_activity.authorized?(@user)).to be false
        #@teaching_activity.add_authorized_member(@user)
        #@teaching_activity.reload
        #expect(@teaching_activity.authorized?(@user)).to be true
      #end

      #it '#add_authorized_member' do
        #expect(@teaching_activity.add_authorized_member(@user)).to_not be_nil
        #expect(@teaching_activity.add_authorized_member(@user)).to be_nil
      #end

      #it '#add_authorized_members' do
        #expect(@teaching_activity.add_authorized_members([@user])).to be true
        #@teaching_activity.reload
        #expect(@teaching_activity.authorized?(@user)).to be true

        #expect(@teaching_activity.add_authorized_members([@user])).to be true
      #end

      #it '#remove_authorized_member' do
        #expect(@teaching_activity.remove_authorized_member(@user)).to be_nil
        #@teaching_activity.add_authorized_member(@user)
        #expect(@teaching_activity.remove_authorized_member(@user)).to be @user
      #end

      #it '#remove_authorized_members' do
        #@teaching_activity.add_authorized_members([@user])
        #@teaching_activity.reload
        #expect(@teaching_activity.authorized?(@user)).to be true

        #expect(@teaching_activity.remove_authorized_members([@user])).to be true
        #@teaching_activity.reload
        #expect(@teaching_activity.authorized?(@user)).to be false
      #end

      #it '#all_viewers' do
        #expect(@teaching_activity.all_viewers.to_a).to eq @teaching_activity.managers.to_a

        #@parent_activity = create(:teaching_activity)
        #@teaching_activity.parent = @parent_activity
        #@teaching_activity.save

        #@managers = @teaching_activity.managers + @parent_activity.managers

        #@members = 2.times.map{create(:user)}
        #@teaching_activity.add_members @members

        #@authorized_members = 2.times.map{create(:user)}
        #@teaching_activity.add_authorized_members @authorized_members

        #@teaching_activity.reload
        #expect(@teaching_activity.all_viewers.to_a.sort).to eq (@managers + @members + @authorized_members).sort
      #end


      #it '#all_viewer_ids' do
        #expect(@teaching_activity.all_viewer_ids).to eq @teaching_activity.manager_ids

        #@parent_activity = create(:teaching_activity)
        #@teaching_activity.parent = @parent_activity
        #@teaching_activity.save

        #@managers = @teaching_activity.managers + @parent_activity.managers

        #@members = 2.times.map{create(:user)}
        #@teaching_activity.add_members @members

        #@authorized_members = 2.times.map{create(:user)}
        #@teaching_activity.add_authorized_members @authorized_members

        #@teaching_activity.reload
        #expect(@teaching_activity.all_viewer_ids.to_a.sort).to eq (@managers + @members + @authorized_members).map(&:id).sort
      #end

      #it '#could_view?' do
        #@manager = @teaching_activity.managers.first
        #expect(@teaching_activity.could_view?(@manager)).to be true

        #@parent_activity = create(:teaching_activity)
        #@teaching_activity.parent = @parent_activity
        #@teaching_activity.save
        #@teaching_activity.reload

        #@member = create(:user)
        #@teaching_activity.add_member @member

        #@authorized_member = create(:user)
        #@teaching_activity.add_authorized_member @authorized_member

        #@teaching_activity.reload

        #expect(@teaching_activity.could_view?(@parent_activity.managers.first)).to be true
        #expect(@teaching_activity.could_view?(@member)).to be true
        #expect(@teaching_activity.could_view?(@authorized_member)).to be true
      #end

    end
  end
end
