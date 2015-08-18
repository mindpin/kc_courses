KcCourses::Engine.routes.draw do
  resources :chapters
  root 'home#index'
end
