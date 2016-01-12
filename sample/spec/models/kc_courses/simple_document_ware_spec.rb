require 'rails_helper'

RSpec.describe KcCourses::SimpleDocumentWare, type: :model do
  describe "基础字段" do
    it{
      @ware = create(:simple_document_ware)
      expect(@ware.respond_to?(:file_entity)).to eq(true)
    }
  end
end
