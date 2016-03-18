Rails.application.routes.draw do
  resources :joins, shallow: true

  resources :courses, shallow: true do
    post :publish, on: :member

    resources :chapters, shallow: true do
      member do
        put :move_up
        put :move_down
      end
      resources :wares, shallow: true do
        member do
          put :move_up
          put :move_down
        end
      end
    end
  end

  root 'home#index'

  mount KcCourses::Engine => '/', :as => 'kc_courses'
  FilePartUpload::Routing.mount "/file_part_upload", :as => :file_part_upload
  mount PlayAuth::Engine => '/auth', :as => :auth
end
