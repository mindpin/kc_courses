Rails.application.routes.draw do
  mount KcCourses::Engine => '/', :as => 'kc_courses'
  FilePartUpload::Routing.mount "/file_part_upload", :as => :file_part_upload
  mount PlayAuth::Engine => '/auth', :as => :auth
end
