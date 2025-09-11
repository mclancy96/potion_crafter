# frozen_string_literal: true

class Ingredient < ApplicationRecord
  has_many :potion_ingredients, dependent: :destroy
  has_many :potions, through: :potion_ingredients

  validates :name, :description, :rarity, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :rarity, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def rarity_badge_color
    case rarity
    when 5
      "danger"
    when 4
      "warning"
    when 3
      "info"
    when 2
      "primary"
    else
      "secondary"
    end
  end
end
