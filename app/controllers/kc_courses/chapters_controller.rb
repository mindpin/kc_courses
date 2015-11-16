module KcCourses
  class ChaptersController < KcCourses::ApplicationController
    before_action :set_course, only: [:create, :new]

    def index
      @chapters = current_user.chapters
    end

    def show
      @chapter = current_user.chapters.find params[:id]
      @wares = @chapter.wares
      #authorize! :manage, @chapter
      #@course = @chapter.course
      #@course_wares = @chapter.course_wares
    end

    def new
      @chapter = current_user.chapters.new course: @course

      #authorize! :manage, Chapter
      #@course = Course.find(params[:course_id])
      #@chapter = KcCourses::Chapter.new

      #if request.xhr?
        #return render :json => {
          #:html => (
            #render_cell :course, :chapter_table_ajax_form, :chapter => @chapter
          #)
        #}
      #end
    end

    def create
      @chapter = current_user.chapters.new chapter_params.merge(course: @course)
      #authorize! :manage, Chapter
      #@course = Course.find(params[:course_id])
      #@chapter = KcCourses::Chapter.build(params[:chapter])
      #@chapter.creator = current_user
      #if @chapter.save
        #if request.xhr?
          #return render :json => {
            #:count => KcCourses::Chapter.count,
            #:html => (
              #render_cell :course_ware, :manage_chapter_table, :chapters => [@chapter]
            #)
          #}
        #end

        #return redirect_to "/manage/courses/#{@course.id}"
      #end
      return redirect_to @chapter if @chapter.save
      render :action => :new
    end

    def edit
      @chapter = current_user.chapters.find(params[:id])
      #authorize! :manage, @chapter
      #@course = @chapter.course

      #if request.xhr?
        #return render :json => {
          #:html => (
            #render_cell :admin, :chapter_ajax_edit_form, :chapter => @chapter, :user => current_user
          #)
        #}
      #end
    end


    def update
      @chapter = current_user.chapters.find(params[:id])
      return redirect_to @chapter if @chapter.update_attributes chapter_params
      render :action => :new
      #authorize! :manage, @chapter
      #@course = @chapter.course
      #if @chapter.update_attributes params[:chapter]
        
        #if request.xhr?
          #return render :json => {
            #:html => (
              #render_cell :course, :chapter_baseinfo, :chapter => @chapter
            #)
          #}
        #end

        #return redirect_to "/manage/chapters/#{@chapter.id}"
      #end
      #render :action => :edit, :id => @chapter.id
    end

    def destroy
      @chapter = current_user.chapters.find(params[:id])
      course_id = @chapter.course_id
      @chapter.destroy
      redirect_to course_path(course_id)
      #authorize! :manage, @chapter
      #@course = @chapter.course
      #@chapter.destroy

      #if request.xhr?
        #return render :json => {
          #:status => 'ok',
          #:count => KcCourses::Chapter.count
        #}
      #end

      #redirect_to "/manage/courses/#{@course.id}"
    end

    def move_up
      @chapter = current_user.chapters.find(params[:id])
      @chapter.move_up
      redirect_to @chapter.course
      #@chapter = KcCourses::Chapter.find(params[:id])
      #authorize! :manage, @chapter
      #@course = @chapter.course
      #@chapter.move_up

      #if request.xhr?
        #return render :json => {
          #:status => 'ok',
          #:html => (render_cell :course_ware, :manage_chapter_table, :chapters => [@chapter])
        #}
      #end

      #return redirect_to "/manage/courses/#{@course.id}"
    end

    def move_down
      @chapter = current_user.chapters.find(params[:id])
      @chapter.move_down
      redirect_to @chapter.course
      #@chapter = KcCourses::Chapter.find(params[:id])
      #authorize! :manage, @chapter
      #@course = @chapter.course
      #@chapter.move_down

      #if request.xhr?
        #return render :json => {
          #:status => 'ok',
          #:html => (render_cell :course_ware, :manage_chapter_table, :chapters => [@chapter])
        #}
      #end

      #return redirect_to "/manage/courses/#{@course.id}"
    end

    private
    def set_course
      @course = current_user.courses.find params[:course_id]
    end

    def chapter_params
      params.require(:chapter).permit(:title, :desc)
    end

  end
end

