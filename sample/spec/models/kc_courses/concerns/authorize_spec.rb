require 'rails_helper'

RSpec.describe KcCourses::Concerns::Authorize, type: :module do
  describe KcCourses::TeachingGroup, type: :model do
    before do
      @teaching_group = create(:teaching_group)
    end

    describe "relationships" do
      it "#authorized_members" do
        expect(@teaching_group.respond_to?(:authorized_members)).to be true
      end
    end

    describe "methods" do
      before do
        @user = create(:user)
      end

      it '#authorized?' do
        expect(@teaching_group.authorized?(@user)).to be false
        @teaching_group.add_authorized_member(@user)
        @teaching_group.reload
        expect(@teaching_group.authorized?(@user)).to be true
      end

      it '#add_authorized_member' do
        expect(@teaching_group.add_authorized_member(@user)).to_not be_nil
        expect(@teaching_group.add_authorized_member(@user)).to be_nil
      end

      it '#add_authorized_members' do
        expect(@teaching_group.add_authorized_members([@user])).to be true
        @teaching_group.reload
        expect(@teaching_group.authorized?(@user)).to be true

        expect(@teaching_group.add_authorized_members([@user])).to be true
      end

      it '#remove_authorized_member' do
        expect(@teaching_group.remove_authorized_member(@user)).to be_nil
        @teaching_group.add_authorized_member(@user)
        expect(@teaching_group.remove_authorized_member(@user)).to be @user
      end

      it '#remove_authorized_members' do
        @teaching_group.add_authorized_members([@user])
        @teaching_group.reload
        expect(@teaching_group.authorized?(@user)).to be true

        expect(@teaching_group.remove_authorized_members([@user])).to be true
        @teaching_group.reload
        expect(@teaching_group.authorized?(@user)).to be false
      end

      it '#all_manager_ids' do
        expect(@teaching_group.all_manager_ids).to eq @teaching_group.manager_ids

        @parent_group = create(:teaching_group)
        @teaching_group.parent = @parent_group
        @teaching_group.save
        @teaching_group.reload
        expect(@teaching_group.all_manager_ids.sort).to eq (@teaching_group.manager_ids + @parent_group.manager_ids).sort
      end

      it '#all_managers' do
        expect(@teaching_group.all_managers.to_a).to eq @teaching_group.managers.to_a

        @parent_group = create(:teaching_group)
        @teaching_group.parent = @parent_group
        @teaching_group.save
        @teaching_group.reload
        expect(@teaching_group.all_managers.to_a.sort).to eq (@teaching_group.managers + @parent_group.managers).sort
      end

      it '#all_viewers' do
        expect(@teaching_group.all_viewers.to_a).to eq @teaching_group.managers.to_a

        @parent_group = create(:teaching_group)
        @teaching_group.parent = @parent_group
        @teaching_group.save

        @managers = @teaching_group.managers + @parent_group.managers

        @members = 2.times.map{create(:user)}
        @teaching_group.add_members @members

        @authorized_members = 2.times.map{create(:user)}
        @teaching_group.add_authorized_members @authorized_members

        @teaching_group.reload
        expect(@teaching_group.all_viewers.to_a.sort).to eq (@managers + @members + @authorized_members).sort
      end


      it '#all_viewer_ids' do
        expect(@teaching_group.all_viewer_ids).to eq @teaching_group.manager_ids

        @parent_group = create(:teaching_group)
        @teaching_group.parent = @parent_group
        @teaching_group.save

        @managers = @teaching_group.managers + @parent_group.managers

        @members = 2.times.map{create(:user)}
        @teaching_group.add_members @members

        @authorized_members = 2.times.map{create(:user)}
        @teaching_group.add_authorized_members @authorized_members

        @teaching_group.reload
        expect(@teaching_group.all_viewer_ids.to_a.sort).to eq (@managers + @members + @authorized_members).map(&:id).sort
      end

      it '#could_manage?' do
        @manager = @teaching_group.managers.first
        expect(@teaching_group.could_manage?(@manager)).to be true

        @parent_group = create(:teaching_group)
        @teaching_group.parent = @parent_group
        @teaching_group.save
        @teaching_group.reload

        expect(@teaching_group.could_manage?(@parent_group.managers.first)).to be true
      end

      it '#could_view?' do
        @manager = @teaching_group.managers.first
        expect(@teaching_group.could_view?(@manager)).to be true

        @parent_group = create(:teaching_group)
        @teaching_group.parent = @parent_group
        @teaching_group.save
        @teaching_group.reload

        @member = create(:user)
        @teaching_group.add_member @member

        @authorized_member = create(:user)
        @teaching_group.add_authorized_member @authorized_member

        @teaching_group.reload

        expect(@teaching_group.could_view?(@parent_group.managers.first)).to be true
        expect(@teaching_group.could_view?(@member)).to be true
        expect(@teaching_group.could_view?(@authorized_member)).to be true
      end

    end
  end
end
