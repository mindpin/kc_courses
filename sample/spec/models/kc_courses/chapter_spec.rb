require 'rails_helper'

RSpec.describe KcCourses::Chapter, type: :model do
  describe "基础字段" do
    it{
      @chapter = create(:chapter)
      expect(@chapter.name).to match(/章节\d+/)
      expect(@chapter.desc).to match(/章节\d+ 描述/)
      expect(@chapter.creator).not_to be_nil
    }

    it{
      @chapter = build(:chapter, name: '')
      @chapter.valid?
      expect(@chapter.name).not_to be_blank
    }

    it{
      @chapter = build(:chapter, course: nil)
      @chapter.valid?
      expect(@chapter.errors[:course].size).to eq(1)
    }

    # 自动设置默认章节了
    #it{
      #@chapter = build(:chapter, name: '')
      #@chapter.valid?
      #p @chapter.errors
      #expect(@chapter.errors[:name].size).to eq(1)
    #}
  end
end
