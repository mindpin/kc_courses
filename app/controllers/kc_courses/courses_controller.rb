module KcCourses
  class CoursesController < KcCourses::ApplicationController

    def index
      @courses = KcCourses::Course.all
    end
    
    def show
      @course = KcCourses::Course.find params[:id]
      @chapters = @course.chapters
    end

    def new
      @course = KcCourses::Course.new
    end

    def create
      @course = KcCourses::Course.new course_params
      return redirect_to @course if @course.save
      render :action => :new
    end

    def edit
      @course = KcCourses::Course.find(params[:id])
    end


    def update
      @course = KcCourses::Course.find(params[:id])
      return redirect_to @course if @course.update_attributes course_params
      render :action => :new
    end

    def destroy
      @course = KcCourses::Course.find(params[:id])
      @course.destroy
      redirect_to courses_path
    end

    def publish
      @course = KcCourses::Course.find(params[:id])
      redirect_to courses_path if @course.publish!
    end

    private
    def course_params
      params.require(:course).permit(:title, :desc)
    end
  end
end


