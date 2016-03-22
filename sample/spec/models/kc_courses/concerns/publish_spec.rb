require 'rails_helper'

class PublishTest
  include Mongoid::Document
  include KcCourses::Concerns::Publish
end

RSpec.describe KcCourses::Concerns::Publish, type: :module do
  describe "基础字段" do
    it{
      @test = PublishTest.create
      expect(@test.respond_to? :published).to eq(true)
      expect(@test.respond_to? :publish!).to eq(true)
      expect(@test.respond_to? :unpublish!).to eq(true)

      expect(@test.published).to eq(false)
      expect(@test.published_at).to be_nil
    }
  end

end
