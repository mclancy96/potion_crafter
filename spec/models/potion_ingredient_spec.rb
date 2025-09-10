# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PotionIngredient, type: :model do
  describe 'associations' do
   it { should belong_to(:potion) }
   it { should belong_to(:ingredient) }
  end

  describe "attribute validations" do
    it 'is valid with a potion and ingredient' do
      potion_ingredient = build(:potion_ingredient)
      expect(potion_ingredient).to be_valid
    end

    it 'is invalid without a potion' do
      potion_ingredient = build(:potion_ingredient, potion_id: nil)
      expect(potion_ingredient).not_to be_valid
    end

    it 'is invalid without an ingredient' do
      potion_ingredient = build(:potion_ingredient, ingredient_id: nil)
      expect(potion_ingredient).not_to be_valid
    end

    it 'is invalid without an quantity' do
      potion_ingredient = build(:potion_ingredient, quantity: nil)
      expect(potion_ingredient).not_to be_valid
    end

  end

end
