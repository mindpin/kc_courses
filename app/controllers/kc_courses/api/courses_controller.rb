module KcCourses
  module Api
    class CoursesController < KcCourses::ApplicationController
      def progress
        user = current_user
        course = KcCourses::Course.find(params[:id])
        render :json => {
          :id => course.id.to_s,
          :spent_time => course.spent_time_of_user(user),
          :title => course.title,
          :current_ware => {
            :id => 
              if course.studing_ware_of_user(user) == nil
                nil
              else
                course.studing_ware_of_user(user).id.to_s
              end,
            :title => 
              if course.studing_ware_of_user(user) == nil
                nil
              else
                course.studing_ware_of_user(user).title
              end
          },
          :percent => course.read_percent_of_user(user),
          :chapters => course.chapters.map do |chapter|
            {
              :id => chapter.id.to_s,
              :title => chapter.title,
              :percent => chapter.read_percent_of_user(user),
              :wares => chapter.wares.map do |ware|
                {
                  :id => ware.id.to_s,
                  :title => ware.title,
                  :percent => ware.read_percent_of_user(user)
                }
              end
            }
          end
        }
      end
    end
  end
end
