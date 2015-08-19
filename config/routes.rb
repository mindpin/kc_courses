KcCourses::Engine.routes.draw do
  resources :courses
  resources :chapters
  root 'home#index'
end
