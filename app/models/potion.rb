# frozen_string_literal: true

class Potion < ApplicationRecord
  belongs_to :user
  has_many :potion_ingredients
  has_many :ingredients, through: :potion_ingredients
  accepts_nested_attributes_for :potion_ingredients, allow_destroy: true
end
