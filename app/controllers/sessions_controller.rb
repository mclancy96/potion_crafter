# frozen_string_literal: true

class SessionsController < ApplicationController
  def new
    redirect_to root_path if logged_in?
    @user = User.new
  end

  def create
    user = User.find_by(username: user_params[:username])
    return handle_user_not_found unless user

    authenticated_user = user.authenticate(user_params[:password])
    return handle_invalid_password unless authenticated_user

    session[:user_id] = authenticated_user.id
    @user = authenticated_user
    redirect_to root_path
  end

  def destroy
    session.delete :user_id
    redirect_to root_path
  end

  private

  def handle_user_not_found
    flash[:alert] = 'User not found'
    redirect_to login_path
  end

  def handle_invalid_password
    flash[:alert] = 'Invalid password'
    @user = User.new(username: user_params[:username])
    render :new, status: :unprocessable_entity
  end

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end
end
