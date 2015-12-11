KcCourses::Engine.routes.draw do
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

  namespace :api do
    get "/courses/:id/progress" => "courses#progress"
    post "/wares/:id/study" => "wares#study"
  end

  # resources :chapters
  # resources :wares
  root 'home#index'
end
