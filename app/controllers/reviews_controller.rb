# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :require_logged_in
  before_action :set_potion

  def index
    @reviews = @potion.reviews
    @review = Review.new
    redirect_to potion_path(@potion) if @reviews.empty?
  end

  def edit; end

  def create
    @review = Review.new(review_params)
    @review.user_id = current_user.id
    @review.potion_id = @potion.id
    if @review.save
      flash[:notice] = "Review created successfully"
      redirect_to potion_reviews_path(@potion)
    else
      @reviews = @potion.reviews
      flash.now[:alert] = "Unable to Create Review"
      render :index
    end
  end

private

  def set_potion
    @potion = Potion.find(params[:potion_id])
  end

  def review_params
    params.require(:review).permit(:potion_id, :comment, :rating)
  end
end
