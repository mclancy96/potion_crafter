# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @potions = @user.potions
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "User Created"
      redirect_to root_path
    else
      flash[:alert] = "Unable to Create User"
      render :new, status: :unprocessable_entity
    end
  end

private

  def user_params
    params.expect(user: %i[username password password_confirmation])
  end
end
