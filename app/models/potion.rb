# frozen_string_literal: true

class Potion < ApplicationRecord
  belongs_to :user
  has_many :potion_ingredients, dependent: :destroy
  has_many :ingredients, through: :potion_ingredients
  has_many :reviews, dependent: :destroy
  accepts_nested_attributes_for :potion_ingredients, allow_destroy: true,
                                                     reject_if: proc { |attrs|
                                                       attrs['ingredient_id'].blank? ||
                                                         attrs['quantity'].blank? ||
                                                         attrs['quantity'].to_s.strip.empty? ||
                                                         attrs['ingredient_id'].to_s.strip.empty?
                                                     }
  validate :no_duplicate_ingredients

  validates :name, :description, :effect, :potency_level, :image_url, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :potency_level, numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def display_image_url
    if image_url.present?
      if image_url =~ %r{\Ahttps?://}
        return image_url
      elsif File.exist?(Rails.root.join('app', 'assets', 'images', image_url))
        return ActionController::Base.helpers.asset_path(image_url)
      end
    end

    ActionController::Base.helpers.asset_path('potion_bottle_placeholder.jpg')
  end

  def ingredient_options(potion_ingredient)
    current_ingredients = potion_ingredients.reject(&:marked_for_destruction?).map(&:ingredient_id)
    excluded_ids = current_ingredients - [potion_ingredient.ingredient_id]
    Ingredient.where.not(id: excluded_ids)
  end

  def overall_rating
    reviews.average(:rating).to_f
  end

  private

  def no_duplicate_ingredients
    ids = potion_ingredients.map(&:ingredient_id).reject(&:blank?)
    return unless ids.size != ids.uniq.size

    errors.add(:potion_ingredients, "can't have duplicate ingredients")
  end
end
