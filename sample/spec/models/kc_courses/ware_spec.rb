require 'rails_helper'

RSpec.describe KcCourses::Ware, type: :model do
  describe "基础字段" do
    it{
      @ware = create(:ware)
      expect(@ware.title).to match(/课件\d+/)
      expect(@ware.desc).to match(/课件\d+ 描述/)
      expect(@ware.user).not_to be_nil
    }

    it{
      @ware = build(:ware, chapter: nil)
      @ware.valid?
      expect(@ware.errors[:chapter].size).to eq(1)
    }
  end
end

