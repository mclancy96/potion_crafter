# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :require_logged_in
  before_action :set_potion
  before_action :set_review, only: %i[update edit]

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

  def update
    if @review.update(review_params)
      flash[:notice] = "Review updated successfully"
      redirect_to potion_reviews_path(@potion)
    else
      flash[:alert] = "Unable to Update Review"
      render :edit
    end
  end

private

  def set_potion
    @potion = Potion.find(params[:potion_id])
  end

  def set_review
    @review = Review.find(params[:id])
  end

  def review_params
    params.expect(review: %i[potion_id comment rating])
  end
end
