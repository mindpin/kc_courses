KcCourses::Engine.routes.draw do
  resources :courses do
    resources :chapters
  end
  root 'home#index'
end
