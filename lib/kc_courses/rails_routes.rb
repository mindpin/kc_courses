module KcCourses
  class Routing
    def self.mount(prefix, options)
      KcCourses.set_mount_prefix prefix

      Rails.application.routes.draw do
        mount KcCourses::Engine => prefix, :as => options[:as]
      end
    end
  end
end

