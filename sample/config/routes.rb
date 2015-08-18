Rails.application.routes.draw do
  mount KcCourses::Engine => '/', :as => 'kc_courses'
  mount PlayAuth::Engine => '/auth', :as => :auth
end
