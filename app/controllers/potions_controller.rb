# frozen_string_literal: true

class PotionsController < ApplicationController
  before_action :require_logged_in
  before_action :set_potion, only: %i[edit show update destroy]

  def index
    @selected_filter = params[:filter_potency_level].present? ? params[:filter_potency_level].to_i : 0
    @selected_sort = params[:sort_potion_method].present? ? params[:sort_potion_method].to_i : 0

    filtered_potions = Potion.by_potency_level_option(@selected_filter)
    @potions = Potion.sort_by_option(@selected_sort, filtered_potions)
  end

  def show
    @review = Review.new
  end

  def new
    @potion = Potion.new
    3.times { @potion.potion_ingredients.build }
  end

  def edit
    3.times { @potion.potion_ingredients.build }
  end

  def create
    @potion = Potion.new(potion_params)
    @potion.user_id = current_user.id
    if @potion.save
      flash[:notice] = "#{@potion.name} created successfully"
      redirect_to potion_path(@potion)
    else
      3.times { @potion.potion_ingredients.build }
      flash.now[:alert] = "Unable to Create Potion"
      render :new
    end
  end

  def update
    if @potion.update(potion_params)
      flash[:notice] = "#{@potion.name} updated successfully"
      redirect_to potion_path(@potion)
    else
      3.times { @potion.potion_ingredients.build }
      flash.now[:alert] = "Unable to Update Potion"
      render :edit
    end
  end

  def destroy
    if @potion.destroy
      flash[:notice] = "#{@potion.name} deleted successfully"
      redirect_to potions_path
    else
      flash.now[:alert] = "Unable to delete Potion"
      render :show
    end
  end

private

  # rubocop:disable Rails/StrongParametersExpect
  def potion_params
    params.require(:potion).permit(
      :name,
      :description,
      :user_id,
      :effect,
      :potency_level,
      :image_url,
      potion_ingredients_attributes: %i[ingredient_id quantity id _destroy]
    )
  end
  # rubocop:enable Rails/StrongParametersExpect

  def set_potion
    @potion = Potion.find(params[:id])
  end
end
