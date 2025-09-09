# frozen_string_literal: true

class AddImageUrlToPotions < ActiveRecord::Migration[8.0]
  def change
    add_column :potions, :image_url, :string
  end
end
