KcCourses::Engine.routes.draw do
  namespace :api do
    get "/courses/:id/progress" => "courses#progress", as: :api_course_progress
    post "/wares/:id/study" => "wares#study"
  end
end
