# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :potion_ingredients
  has_many :potions, through: :potion_ingredients
end
