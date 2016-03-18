class WaresController < ApplicationController
  before_action :set_chapter, only: [:new, :create]
  def show
    @ware = current_user.wares.find params[:id]
  end

  def new
    @ware = current_user.wares.new chapter: @chapter
  end

  def create
    @ware = current_user.wares.new ware_params.merge(chapter: @chapter)
    return redirect_to @chapter if @ware.save
    render :action => :new
  end

  def edit
    @ware = current_user.wares.find(params[:id])
  end


  def update
    @ware = current_user.wares.find(params[:id])
    return redirect_to @ware.chapter if @ware.update_attributes ware_params
    render :action => :new
  end

  def destroy
    @ware = current_user.wares.find(params[:id])
    @chapter = @ware.chapter
    @ware.destroy
    redirect_to @chapter
  end

  def move_up
    @ware = current_user.wares.find(params[:id])
    @chapter = @ware.chapter
    @ware.move_up

    return redirect_to @chapter
  end

  def move_down
    @ware = current_user.wares.find(params[:id])
    @chapter = @ware.chapter
    @ware.move_down

    return redirect_to @chapter
  end

  protected
  def set_chapter
    @chapter = current_user.chapters.find params[:chapter_id]
  end

  def ware_params
    params.require(:ware).permit(:title, :desc)
  end
end
