module KcCourses
  class SimpleDocumentWare < Ware
    belongs_to :file_entity, class_name: 'FilePartUpload::FileEntity'
  end
end
