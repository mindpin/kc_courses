require 'rails_helper'

RSpec.describe KcCourses::Ware, type: :model do
  describe "基础字段" do
    it{
      @ware = create(:ware)
      expect(@ware.title).to eq("课件1")
      expect(@ware.desc).to eq("课件1 描述")
    }

    it{
      @ware = build(:ware, chapter: nil)
      @ware.valid?
      expect(@ware.errors[:chapter].size).to eq(1)
    }
  end
end

