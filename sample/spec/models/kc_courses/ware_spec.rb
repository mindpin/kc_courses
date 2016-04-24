require 'rails_helper'

RSpec.describe KcCourses::Ware, type: :model do
  describe "基础字段" do
    it{
      @ware = create(:ware)
      expect(@ware.name).to match(/课件\d+/)
      expect(@ware.desc).to match(/课件\d+ 描述/)
      expect(@ware.creator).not_to be_nil
    }
  end
end
