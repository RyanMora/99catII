class SessionsController < ApplicationController
  before_action :logged_in, only: [:new, :create]

  def new
    @user = User.new
    render :new
  end

  def create
    @user = User.find_by_credentials(params[:user][:user_name], params[:user][:password])
    if @user
      @user.reset_session_token!
      login(@user)
      redirect_to cats_url
    else
      redirect_to new_user_url
    end
  end

  def destroy
    current_user.reset_session_token! if current_user
    session[:session_token] = nil
    redirect_to cats_url
  end

  private

  def logged_in
    redirect_to cats_url if current_user
  end
end
