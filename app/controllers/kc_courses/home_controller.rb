module KcCourses
  class HomeController < KcCourses::ApplicationController
    def index
      @courses_count = KcCourses::Course.count
      @chapters_count = KcCourses::Chapter.count
      @wares_count = KcCourses::Ware.count
    end
  end
end
