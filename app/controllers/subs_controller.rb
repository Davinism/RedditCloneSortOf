class SubsController < ApplicationController
  before_action :check_if_moderator, only: [:edit]

  def index
    @subs = Sub.all
    render :index
  end

  def new

  end

  def create
    @sub = Sub.new(sub_params)
    @sub.user_id = current_user.id

    if @sub.save
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :new
    end

  end

  def show
    @sub = Sub.find_by_id(params[:id])
    render :show
  end

  def update
    @sub = current_user.subs.find(params[:id])

    if @sub.update(sub_params)
      redirect_to sub_url(@sub)
    else
      flash.now[:errors] = @sub.errors.full_messages
      render :edit
    end


  end

  def edit
    @sub = Sub.find(params[:id])

    if @sub.nil?
      flash[:errors] = ["You are not the moderator and cannot edit this sub!"]
      redirect_to subs_url
    else
      render :edit
    end
  end

  def destroy
    @sub = current_user.subs.find(params[:id])
    @sub.destroy
  end

  def sub_params
    params.require(:sub).permit(:title, :description)
  end

  def check_if_moderator
    @sub = Sub.find(params[:id])
    if current_user.nil? || !(current_user.id == @sub.user_id)
      redirect_to new_session_url
    end
  end

end
