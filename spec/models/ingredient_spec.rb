# frozen_string_literal: true

require "rails_helper"

RSpec.describe Ingredient do
  describe "associations" do
    it { is_expected.to have_many(:potion_ingredients) }
    it { is_expected.to have_many(:potions).through(:potion_ingredients) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:rarity) }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_numericality_of(:rarity).is_greater_than_or_equal_to(1).is_less_than_or_equal_to(10) }
  end

  describe "attribute validation" do
    it "is valid with valid attributes" do
      ingredient = build(:ingredient)
      expect(ingredient).to be_valid
    end

    it "is invalid without a name" do
      ingredient = build(:ingredient, name: nil)
      expect(ingredient).not_to be_valid
    end

    it "is invalid with duplicate name" do
      create(:ingredient, name: "Bob")
      new_ingredient = build(:ingredient, name: "Bob")
      expect(new_ingredient).not_to be_valid
    end

    it "is invalid without a description" do
      ingredient = build(:ingredient, description: nil)
      expect(ingredient).not_to be_valid
    end

    it "is invalid without a rarity" do
      ingredient = build(:ingredient, rarity: nil)
      expect(ingredient).not_to be_valid
    end

    it "is invalid with rarity < 1" do
      ingredient = build(:ingredient, rarity: 0)
      expect(ingredient).not_to be_valid
    end

    it "is invalid with rarity > 10" do
      ingredient = build(:ingredient, rarity: 11)
      expect(ingredient).not_to be_valid
    end
  end

  describe "#rarity_badge_color" do
    it "returns danger for rarity 5" do
      ingredient = build(:ingredient, rarity: 5)
      expect(ingredient.rarity_badge_color).to eq("danger")
    end

    it "returns warning for rarity 4" do
      ingredient = build(:ingredient, rarity: 4)
      expect(ingredient.rarity_badge_color).to eq("warning")
    end

    it "returns info for rarity 3" do
      ingredient = build(:ingredient, rarity: 3)
      expect(ingredient.rarity_badge_color).to eq("info")
    end

    it "returns primary for rarity 2" do
      ingredient = build(:ingredient, rarity: 2)
      expect(ingredient.rarity_badge_color).to eq("primary")
    end

    it "returns secondary for rarity 1" do
      ingredient = build(:ingredient, rarity: 1)
      expect(ingredient.rarity_badge_color).to eq("secondary")
    end

    it "returns secondary for rarity outside 1-5" do
      ingredient = build(:ingredient, rarity: 0)
      expect(ingredient.rarity_badge_color).to eq("secondary")
      ingredient = build(:ingredient, rarity: 6)
      expect(ingredient.rarity_badge_color).to eq("secondary")
    end
  end
end
