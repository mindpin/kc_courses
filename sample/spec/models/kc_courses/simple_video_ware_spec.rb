require 'rails_helper'

RSpec.describe KcCourses::SimpleVideoWare, type: :model do
  describe "基础字段" do
    it{
      @ware = create(:simple_video_ware)
      expect(@ware.respond_to?(:file_entity)).to eq(true)
    }
  end
end
