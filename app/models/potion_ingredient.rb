# frozen_string_literal: true

class PotionIngredient < ApplicationRecord
  belongs_to :ingredient
  belongs_to :potion
end
