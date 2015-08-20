KcCourses::Engine.routes.draw do
  resources :courses do
    post :publish, on: :member

    resources :chapters do
      member do
        put :move_up
        put :move_down
      end
    end
  end
  root 'home#index'
end
