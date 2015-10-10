module KcCourses
  class FavoritesController < KcCourses::ApplicationController

    def index
      @favorites = current_user.favorites
    end
    
    def create
      @favorite = current_user.favorites.new course_id: params[:course_id]
      return redirect_to favorites_path if @favorite.save
      redirect_to course_path(params[:course_id])
    end

    def destroy
      @favorite = current_user.favorites.find params[:id]
      @favorite.destroy
      redirect_to favorites_path
    end
  end
end
