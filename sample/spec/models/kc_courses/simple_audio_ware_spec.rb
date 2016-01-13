require 'rails_helper'

RSpec.describe KcCourses::SimpleAudioWare, type: :model do
  describe "基础字段" do
    it{
      @ware = create(:simple_audio_ware)
      expect(@ware.respond_to?(:file_entity)).to eq(true)
    }
  end
end

