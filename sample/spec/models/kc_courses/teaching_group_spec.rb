require 'rails_helper'

RSpec.describe KcCourses::TeachingGroup, type: :model do
  it { should validate_presence_of :name }

  it "attributes" do
    @teaching_group = create(:teaching_group)
    expect(@teaching_group.respond_to?(:name)).to eq true
    expect(@teaching_group.respond_to?(:desc)).to eq true
    #expect(@teaching_group.respond_to?(:icon)).to eq true
  end

  it "relationships" do
    @teaching_group = create(:teaching_group)
    expect(@teaching_group.respond_to?(:managers)).to eq true
    expect(@teaching_group.respond_to?(:members)).to eq true

    expect(@teaching_group.respond_to?(:activities)).to eq true
  end

  describe "methods" do
    before do
      @teaching_group = create(:teaching_group)
      @user = create(:user)
    end

    # 判断user是否为组员
    it '#has_member?' do
      expect(@teaching_group.has_member?(@user)).to eq false
    end

    # 判断user是否为组长
    it '#has_manager?' do
      expect(@teaching_group.has_manager?(@user)).to eq false
    end

    # 增加单个成员
    # 已经添加则返回nil
    it '#add_member' do
      expect(@teaching_group.add_member(@user)).to_not be_nil
    end

    # 增加成员（users 表示 user 数组）
    # 如果 users 中的 user 已经在 members，那么忽略这个 user
    # 如果 users 中的 user 不在 members，那么直接增加到 members
    it '#add_members' do
      expect(@teaching_group.add_members([@user])).to eq true
    end

    # 移除单个成员
    # 如果 user 不在 members，则返回 nil
    # 如果 user 在 members，同时在 managers ，则返回 false
    # 如果 user 在 members，不在 managers ，则移除，返回 user
    it '#remove_member' do
      expect(@teaching_group.remove_member(@user)).to be_nil

      @teaching_group.add_member(@user)
      expect(@teaching_group.remove_member(@user)).to eq @user

      @teaching_group.add_member(@user)
      @teaching_group.add_manager(@user)
      expect(@teaching_group.remove_member(@user)).to eq false
    end


    # 移除成员（users 表示 user 数组）
    # 批量执行移除单个成员
    it '#remove_members' do
      expect(@teaching_group.remove_members([@user])).to eq true
    end

    # 增加组长
    # 如果 user 已经在 managers，返回nil
    # 如果 user 不在 managers，在members，则添加 返回 user
    # 如果 user 不在 managers, 不在members, 则 自动添加进members
    it '#add_manager' do
      expect(@teaching_group.add_manager(@user)).to_not be_nil
      # 自动添加进members
      expect(@teaching_group.has_member?(@user)).to eq true
      expect(@teaching_group.add_manager(@user)).to be_nil
    end

    # 增加组长（users 表示 user 数组）
    # 批量执行增加单个组长
    it '#add_managers' do
      expect(@teaching_group.add_managers([@user])).to eq true
    end

    # 移除组长
    # 如果 user 不在 managers, 返回nil
    # 如果 user 在 managers, 且数量大于1, 返回 user
    # 如果 user 在 managers, 且数量等于1, 返回 false
    it '#remove_manager' do
      expect(@teaching_group.remove_manager(@user)).to be_nil

      # 默认有一位组长, 添加后为两位，可以删除
      @teaching_group.add_manager @user
      expect(@teaching_group.remove_manager(@user)).to eq @user

      # 默认有一位组长，可以删除
      expect(@teaching_group.remove_manager(@teaching_group.managers.first)).to eq false
    end

    # 移除组长（users 表示 user 数组）
    # 批量执行移除单个组长
    # 组长不会为空
    it '#remove_managers' do
      expect(@teaching_group.remove_managers([@user])).to eq true
    end

    # 当组长为空时报错
    it '#require_at_least_one_manager' do
      teaching_group = build(:teaching_group, managers: [])
      expect(teaching_group.send(:require_at_least_one_manager)).to eq [I18n.t('errors.messages.at_least_one')]

      expect(@teaching_group.send(:require_at_least_one_manager)).to be_nil
    end
  end

  describe 'validates' do
    it '必须有组长' do
      teaching_group = build(:teaching_group, managers: [])
      expect(teaching_group).to_not be_valid
      expect(teaching_group.errors[:managers]).to eq ["至少需要一个"]
    end
  end

  # 树状支持
  describe Mongoid::Tree do
    before do
      @node1 = create(:teaching_group)
      @node2 = create(:teaching_group)
    end

    it '#parent' do
      expect(@node1.parent).to be_nil
      @node1.update_attribute :parent, @node2
      expect(@node1.parent).to eq @node2
      @node1.reload
      expect(@node1.parent).to eq @node2
    end

    it '#children' do
      expect(@node1.children).to be_blank
      @node1.children << @node2
      expect(@node1.children).to include(@node2)
      @node1.reload
      expect(@node1.children).to include(@node2)
    end
  end
end
