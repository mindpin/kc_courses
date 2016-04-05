require 'rails_helper'

RSpec.describe KcCourses::UserCourseAuthorize, type: :model do
  before do
    @user_course_authorize = create(:user_course_authorize)
  end

  it "基础字段" do
    expect(@user_course_authorize.respond_to?(:user_id)).to be true
    expect(@user_course_authorize.respond_to?(:course_ids)).to be true
  end

  it "关系" do
    expect(@user_course_authorize.respond_to?(:user)).to be true
    expect(@user_course_authorize.respond_to?(:courses)).to be true
  end
end
