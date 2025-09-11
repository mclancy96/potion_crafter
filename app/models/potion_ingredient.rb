# frozen_string_literal: true

class PotionIngredient < ApplicationRecord
  belongs_to :ingredient
  belongs_to :potion

  validates :quantity, presence: true
end
