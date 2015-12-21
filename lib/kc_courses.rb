module KcCourses
  class << self
    attr_accessor :root, :base_path

    def config(&block)
      # 读取配置
      KcCourses::Config.config(&block)

      # 根据 mode 加载不同的模块
      KcCourses::ModuleLoader.load_by_mode!
    end

    def kc_courses_config
      self.instance_variable_get(:@kc_courses_config) || {}
    end

    def set_mount_prefix(mount_prefix)
      config = KcCourses.kc_courses_config
      config[:mount_prefix] = mount_prefix
      KcCourses.instance_variable_set(:@kc_courses_config, config)
    end

    def get_mount_prefix
      kc_courses_config[:mount_prefix]
    end
  end
end

require 'simple_form'
# 引用 rails engine
require 'kc_courses/engine'
require 'kc_courses/rails_routes'
