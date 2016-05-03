require 'rails_helper'

RSpec.describe KcCourses::Course, type: :model do
  it { should validate_presence_of :name }
  it { should validate_presence_of :creator }

  it "基础字段" do
    @course = create(:course)
    expect(@course.respond_to?(:name)).to be true
    expect(@course.respond_to?(:desc)).to be true

    expect(@course.respond_to?(:creator_id)).to be true
    expect(@course.respond_to?(:cover_file_entity_id)).to be true

    expect(@course.respond_to?(:course_subject_ids)).to be true
  end

  it "关系" do
    @course = create(:course)
    expect(@course.respond_to?(:creator)).to be true
    expect(@course.respond_to?(:cover_file_entity)).to be true
    expect(@course.respond_to?(:course_subjects)).to be true
  end

  describe "scopes" do
    it 'recent' do
      expect(KcCourses::Course.respond_to? :recent).to eq(true)
      @course = create(:course)
      expect(KcCourses::Course.recent.first).to eq(@course)
    end
  end

  describe "methods" do
    it '#get_cover' do
      @course = create(:course)
      expect(@course.respond_to?(:cover)).to be true

      # 没有上传图片
      expect(@course.cover).to eq ENV['course_default_cover_url']

      qiniu_callback_body = {
        bucket: "fushang318",
        token: "/f/IuR0fINf.jpg",
        file_size: "25067",
        original: "1-120GQF34TY.jpg",
        mime: "image/jpeg",
        image_width: "200",
        image_height: "200",
        image_rgb: "0x4f4951"
      }
      @file_entity = FilePartUpload::FileEntity.from_qiniu_callback_body qiniu_callback_body

      @course.update_attribute :cover_file_entity, @file_entity
      expect(@course.cover).to eq @file_entity.url
    end
  end

end
