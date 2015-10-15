module KcCourses
  class JoinsController < KcCourses::ApplicationController

    def index
      @joins = current_user.course_joins
    end
    
    def create
      @join = current_user.course_joins.new course_id: params[:course_id]
      return redirect_to joins_path if @join.save
      redirect_to course_path(params[:course_id])
    end

    def destroy
      @join = current_user.course_joins.find params[:id]
      @join.destroy
      redirect_to joins_path
    end
  end
end
