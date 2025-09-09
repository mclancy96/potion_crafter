# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :current_user
  helper_method :logged_in?, :current_user, :user_is_current_user?

  def current_user
    @user = User.find_by(id: session[:user_id]) || User.new
  end

  def logged_in?
    current_user.id != nil
  end

  def require_logged_in
    redirect_to(controller: "sessions", action: "new") unless logged_in?
  end

  def user_is_current_user?(user = @user)
    user.id == current_user.id
  end
end
