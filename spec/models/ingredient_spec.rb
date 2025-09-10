# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Ingredient, type: :model do
	describe 'associations' do
		it { should have_many(:potion_ingredients) }
		it { should have_many(:potions).through(:potion_ingredients) }
	end

	describe 'validations' do
		it { should validate_presence_of(:name) }
		it { should validate_presence_of(:description) }
		it { should validate_presence_of(:rarity) }
		it { should validate_uniqueness_of(:name).case_insensitive }
		it { should validate_numericality_of(:rarity).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
	end

	describe 'attribute validation' do
		it 'is valid with valid attributes' do
			ingredient = build(:ingredient)
			expect(ingredient).to be_valid
		end

		it 'is invalid without a name' do
			ingredient = build(:ingredient, name: nil)
			expect(ingredient).not_to be_valid
		end

    it 'is invalid with duplicate name' do
      create(:ingredient, name: 'Bob')
      new_ingredient = build(:ingredient, name: 'Bob')
      expect(new_ingredient).not_to be_valid
    end

		it 'is invalid without a description' do
			ingredient = build(:ingredient, description: nil)
			expect(ingredient).not_to be_valid
		end

		it 'is invalid without a rarity' do
			ingredient = build(:ingredient, rarity: nil)
			expect(ingredient).not_to be_valid
		end

		it 'is invalid with rarity < 1' do
			ingredient = build(:ingredient, rarity: 0)
			expect(ingredient).not_to be_valid
		end

		it 'is invalid with rarity > 10' do
			ingredient = build(:ingredient, rarity: 11)
			expect(ingredient).not_to be_valid
		end
	end
end
