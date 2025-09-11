# frozen_string_literal: true

class Potion < ApplicationRecord
  belongs_to :user
  has_many :potion_ingredients, dependent: :destroy
  has_many :ingredients, through: :potion_ingredients
  has_many :reviews, dependent: :destroy
  accepts_nested_attributes_for :potion_ingredients, allow_destroy: true,
                                                     reject_if: proc { |attrs|
                                                       attrs["ingredient_id"].blank? ||
                                                         attrs["quantity"].blank? ||
                                                         attrs["quantity"].to_s.strip.empty? ||
                                                         attrs["ingredient_id"].to_s.strip.empty?
                                                     }
  validate :no_duplicate_ingredients

  validates :name, :description, :effect, :potency_level, :image_url, presence: true
  validates :name, uniqueness: { case_sensitive: false }
  validates :potency_level,
            numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  def display_image_url
    if image_url.present?
      if %r{\Ahttps?://}.match?(image_url)
        return image_url
      elsif Rails.root.join("app", "assets", "images", image_url).exist?
        return ActionController::Base.helpers.asset_path(image_url)
      end
    end

    ActionController::Base.helpers.asset_path("potion_bottle_placeholder.jpg")
  end

  def ingredient_options(potion_ingredient)
    current_ingredients = potion_ingredients.reject(&:marked_for_destruction?).map(&:ingredient_id)
    excluded_ids = current_ingredients - [potion_ingredient.ingredient_id]
    Ingredient.where.not(id: excluded_ids)
  end

  def overall_rating
    avg = reviews.average(:rating)
    avg ? avg.round(2) : 0.0
  end

  def self.potency_level_options
    [
      { id: 0, name: "All", start: 0, end: 10, short_name: "All" },
      { id: 1, name: "0-2: Low", start: 0, end: 2, short_name: "Low" },
      { id: 2, name: "3-5: Medium", start: 3, end: 5, short_name: "Medium" },
      { id: 3, name: "6-8: High", start: 6, end: 8, short_name: "High" },
      { id: 4, name: "9-10: Legendary", start: 9, end: 10, short_name: "Legendary" },
    ]
  end

  def self.by_potency_level_option(option_id)
    option = potency_level_options.find { |opt| opt[:id] == option_id.to_i }
    return Potion.all unless option

    where(potency_level: (option[:start])..(option[:end]))
  end

  def self.sort_options
    [
      { id: 0, name: "Default", attr: :id, direction: :asc },
      { id: 1, name: "Name A -> Z", attr: :name, direction: :asc },
      { id: 2, name: "Name Z -> A", attr: :name, direction: :desc },
      { id: 3, name: "Potency Level 0 -> 9", attr: :potency_level, direction: :asc },
      { id: 4, name: "Potency Level 9 -> 0", attr: :potency_level, direction: :desc },
    ]
  end

  def self.sort_by_option(option_id, potions = Potion.all)
    option = sort_options.find { |opt| opt[:id] == option_id.to_i }
    return potions unless option

    if option[:attr] == :name
      potions.order("LOWER(name) #{option[:direction]}")
    else
      potions.order(option[:attr] => option[:direction])
    end
  end

  def potency_level_option
    self.class.potency_level_options.reject { |opt| opt[:short_name] == "All" }
        .find { |opt| potency_level.between?(opt[:start], opt[:end]) }
  end

  def potency_level_short_name
    option = potency_level_option
    option ? option[:short_name] : "Unknown"
  end

  def potency_level_badge_color
    option = potency_level_option
    case option&.dig(:short_name)
    when "Low"
      "secondary"
    when "Medium"
      "info"
    when "High"
      "warning"
    when "Legendary"
      "danger"
    else
      "primary"
    end
  end

  def overall_rating_badge_color
    case overall_rating
    when 4.5..5
      "success"
    when 3.5...4.5
      "info"
    when 2.5...3.5
      "warning"
    when 1...2.5
      "danger"
    else
      "secondary"
    end
  end

private

  def no_duplicate_ingredients
    ids = potion_ingredients.map(&:ingredient_id).compact_blank
    return unless ids.size != ids.uniq.size

    errors.add(:potion_ingredients, "can't have duplicate ingredients")
  end
end
