class SessionsController < ApplicationController
  def new

  end

  def create
    @user = User.new(
    username: params[:user][:username],
    password: params[:user][:password]
    )

    if @user.save!
      log_in_user!(@user)
      redirect_to user_url(@user)
    else
      flash.now[:errors] = ["Invalid name or password!"]
      render :new
    end
  end

  def destroy
    log_out_user!
    redirect_to new_session_url
  end
end
