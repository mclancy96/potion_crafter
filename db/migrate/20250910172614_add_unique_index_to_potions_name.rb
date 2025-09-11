class AddUniqueIndexToPotionsName < ActiveRecord::Migration[8.0]
  def change
    add_index :potions, :name, unique: true
  end
end
