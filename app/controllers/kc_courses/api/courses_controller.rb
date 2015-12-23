module KcCourses
  module Api
    class CoursesController < KcCourses::ApplicationController
      def progress
        user = current_user
        course = KcCourses::Course.find(params[:id])
        spent_seconds = course.spent_time_of_user(user)
        last_studied_at = course.last_studied_at_of_user(user)
        render :json => {
          :id => course.id.to_s,
          :spent_seconds => spent_seconds,
          :str_spent_time => KcCourses::TimeDiy.pretty_seconds(spent_seconds),
          :last_studied_at => last_studied_at,
          :current_ware => 
            if ware = course.studing_ware_of_user(user)
              {
                :id => ware.id.to_s,
                :title => ware.title
              }
            else
              nil
            end,
          :title => course.title,
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
