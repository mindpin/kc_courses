require 'rails_helper'

RSpec.describe KcCourses::Concerns::DiscussSetting, type: :module do
  describe KcCourses::TeachingGroup, type: :model do
    it "属性" do
      @teaching_group = create(:teaching_group)
      expect(@teaching_group.respond_to?(:enabled)).to be true
      expect(@teaching_group.respond_to?(:all_could_view)).to be true
      expect(@teaching_group.respond_to?(:all_could_post)).to be true

      # 默认值
      expect(@teaching_group.enabled).to be true
      expect(@teaching_group.all_could_view).to be true
      expect(@teaching_group.all_could_post).to be true
    end

    it "关系" do
      #@teaching_group = create(:teaching_group)
      #expect(@teaching_group.respond_to?(:method)).to be true
    end

    describe "方法" do
    end
  end
end
