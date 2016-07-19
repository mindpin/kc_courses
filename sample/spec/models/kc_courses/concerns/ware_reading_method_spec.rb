require 'rails_helper'

RSpec.describe KcCourses::Concerns::WareReadingMethod, type: :module do
  describe KcCourses::Ware do
    before do
      @ware = create(:ware)
      @user = create(:user)
    end

    it "关系" do
      expect(@ware.respond_to? :ware_readings).to eq(true)
      expect(@ware.respond_to? :ware_reading_deltas).to eq(true)
    end

    it "read_percent_of_user" do
      expect(@ware.read_percent_of_user(@user)).to eq 0
    end

    it "set_read_percent_by_user" do
      @percents = [1, 55 ,99, 100]
      @percents.each do |percent|
        expect(@ware.set_read_percent_by_user(@user, percent)).to_not be_nil
        expect(@ware.read_percent_of_user(@user)).to eq percent
      end
    end

    it "set_read_percent_by_user 传入错误的百分比" do
      expect{@ware.set_read_percent_by_user(@user, -1)}.to raise_error(RuntimeError, "传入错误的百分比")
      expect{@ware.set_read_percent_by_user(@user, 101)}.to raise_error(RuntimeError, "传入错误的百分比")
    end

    it "set_read_percent_by_user 传入比原来小的百分比，返回true" do
      @ware.set_read_percent_by_user(@user, 10)
      expect(@ware.set_read_percent_by_user(@user, 9)).to be true
    end
  end
end

