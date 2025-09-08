# frozen_string_literal: true

class Potion < ApplicationRecord
  belongs_to :user
  has_many :potion_ingredients
  has_many :ingredients, through: :potion_ingredients
  accepts_nested_attributes_for :potion_ingredients, allow_destroy: true

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
end
