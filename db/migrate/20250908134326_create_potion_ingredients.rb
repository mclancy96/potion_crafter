class CreatePotionIngredients < ActiveRecord::Migration[8.0]
  def change
    create_table :potion_ingredients do |t|
      t.references :ingredient, null: false, foreign_key: true
      t.references :potion, null: false, foreign_key: true
      t.string :quantity

      t.timestamps
    end
  end
end
