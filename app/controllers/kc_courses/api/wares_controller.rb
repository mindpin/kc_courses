module KcCourses
  module Api
    class WaresController < KcCourses::ApplicationController
      def study
        user = current_user
        ware = KcCourses::Ware.find(params[:id])
        ware.set_read_percent_by_user(user, params[:percent])
        render :json => {
          :id => ware.id.to_s,
          :percent => ware.read_percent_of_user(user)
        }
      end
    end
  end
end