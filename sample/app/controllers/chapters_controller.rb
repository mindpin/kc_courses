class ChaptersController < ApplicationController
  before_action :set_course, only: [:create, :new]

  def show
    @chapter = current_user.chapters.find params[:id]
    @wares = @chapter.wares
  end

  def new
    @chapter = current_user.chapters.new course: @course
  end

  def create
    @chapter = current_user.chapters.new chapter_params.merge(course: @course)
    return redirect_to @chapter if @chapter.save
    render :action => :new
  end

  def edit
    @chapter = current_user.chapters.find(params[:id])
  end


  def update
    @chapter = current_user.chapters.find(params[:id])
    return redirect_to @chapter if @chapter.update_attributes chapter_params
    render :action => :new
  end

  def destroy
    @chapter = current_user.chapters.find(params[:id])
    course_id = @chapter.course_id
    @chapter.destroy
    redirect_to course_path(course_id)
  end

  def move_up
    @chapter = current_user.chapters.find(params[:id])
    @chapter.move_up
    redirect_to @chapter.course
  end

  def move_down
    @chapter = current_user.chapters.find(params[:id])
    @chapter.move_down
    redirect_to @chapter.course
  end

  private
  def set_course
    @course = current_user.courses.find params[:course_id]
  end

  def chapter_params
    params.require(:chapter).permit(:name, :desc)
  end
end
