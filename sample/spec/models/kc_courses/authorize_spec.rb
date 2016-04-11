require 'rails_helper'

RSpec.describe KcCourses::Authorize, type: :model do
  it { should validate_presence_of :value }

  it "属性" do
    @authorize = create(:authorize)
    expect(@authorize.respond_to?(:value)).to be true
  end

  it "关系" do
    @authorize = create(:authorize)
    expect(@authorize.respond_to?(:authorizeable)).to be true
    expect(@authorize.respond_to?(:user)).to be true
  end

  describe "方法" do
  end
end
