module KcCourses
  class WaresController < KcCourses::ApplicationController
    before_action :set_chapter, only: [:new, :create]
    def show
      @ware = KcCourses::Ware.find params[:id]
    end

    def new
      @ware = @chapter.wares.new
    end

    def create
      @ware = @chapter.wares.new ware_params
      return redirect_to @chapter if @ware.save
      render :action => :new
    end

    def edit
      @ware = KcCourses::Ware.find(params[:id])
    end


    def update
      @ware = KcCourses::Ware.find(params[:id])
      return redirect_to @ware.chapter if @ware.update_attributes ware_params
      render :action => :new
    end

    def destroy
      @ware = KcCourses::Ware.find(params[:id])
      @chapter = @ware.chapter
      @ware.destroy
      redirect_to @chapter
    end

    def move_up
      @ware = KcCourses::Ware.find(params[:id])
      @chapter = @ware.chapter
      @ware.move_up

      return redirect_to @chapter
    end

    def move_down
      @ware = KcCourses::Ware.find(params[:id])
      @chapter = @ware.chapter
      @ware.move_down

      return redirect_to @chapter
    end

    protected
    def set_chapter
      @chapter = KcCourses::Chapter.find params[:chapter_id]
    end

    def ware_params
      params.require(:ware).permit(:title, :desc)
    end
  end
end
