module KcCourses
  class ApplicationController < ActionController::Base
    layout "kc_courses/application"

    if defined? PlayAuth
      include PlayAuth::SessionsHelper
      helper PlayAuth::SessionsHelper
    end
  end
end
