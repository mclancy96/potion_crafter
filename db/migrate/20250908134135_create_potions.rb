# frozen_string_literal: true

class CreatePotions < ActiveRecord::Migration[8.0]
  def change
    create_table :potions do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.string :effect
      t.integer :potency_level

      t.timestamps
    end
  end
end
