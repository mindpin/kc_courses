FactoryGirl.define do
  factory :simple_document_ware, class: KcCourses::SimpleDocumentWare do
    sequence(:title){|n| "文档课件#{n}"}
    sequence(:desc){|n| "文档课件#{n} 描述"}
    chapter
    creator {create(:user)}
  end
end
