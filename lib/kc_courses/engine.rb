module KcCourses
  class Engine < ::Rails::Engine
    isolate_namespace KcCourses
    config.to_prepare do
      ApplicationController.helper ::ApplicationHelper
    end
  end
end