# frozen_string_literal: true

class PotionsController < ApplicationController
  before_action :require_logged_in
  before_action :set_potion, only: %i[edit show update]

  def index
    @potions = Potion.all
  end

  def new
    @potion = Potion.new
  end

  def create
    @potion = Potion.new(potion_params)
    if @potion.save
      flash[:notice] = "#{@potion.name} created successfully"
      redirect_to potion_path(@potion)
    else
      flash[:alert] = 'Unable to Create Potion'
      render :new
    end
  end

  def show; end

  def edit; end

  def update; end

  def destroy; end

  private

  def potion_params
    params.require(:potion).permit(
      :name,
      :description,
      :user_id,
      :effect,
      :potency_level,
      ingredient_ids: [],
      potion_ingredients_attributes: %i[ingredient_id quantity id]
    )
  end

  def set_potion
    @potion = Potion.find(params[:id])
  end
end
