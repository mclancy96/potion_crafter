# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Potion, type: :model do
  describe 'associations' do
    it { should have_many(:potion_ingredients) }
    it { should have_many(:ingredients).through(:potion_ingredients) }
    it { should have_many(:reviews) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    subject { create(:potion) }

    it { should validate_presence_of :name }
    it { should validate_uniqueness_of(:name).case_insensitive }
    it { should validate_presence_of :description }
    it { should validate_presence_of :effect }
    it { should validate_presence_of :potency_level }
    it { should validate_numericality_of(:potency_level).is_greater_than_or_equal_to(1) }
    it { should validate_numericality_of(:potency_level).is_less_than_or_equal_to(10) }
    it { should validate_numericality_of(:potency_level).only_integer }
    it { should validate_presence_of :image_url }
  end

  describe 'nested attributes' do
    it 'accepts valid nested potion_ingredients attributes' do
      ingredient = create(:ingredient)
      user = create(:user)
      potion = Potion.new(
        name: "Test Potion",
        description: "desc",
        effect: "effect",
        potency_level: 5,
        image_url: "img.png",
        user: user,
        potion_ingredients_attributes: [
          { ingredient_id: ingredient.id, quantity: 2 }
        ]
      )
      expect(potion).to be_valid
      potion.save
      expect(potion.potion_ingredients.count).to eq(1)
    end

    it 'rejects nested potion_ingredients with blank ingredient_id or quantity' do
      user = create(:user)
      potion = Potion.new(
        name: "Test Potion",
        description: "desc",
        effect: "effect",
        potency_level: 5,
        image_url: "img.png",
        user: user,
        potion_ingredients_attributes: [
          { ingredient_id: nil, quantity: 2 },
          { ingredient_id: 1, quantity: nil }
        ]
      )
      potion.save
      expect(potion.potion_ingredients).to be_empty
    end
    end

    describe '.potency_level_options' do
      it 'returns the correct options array' do
        options = Potion.potency_level_options
        expect(options).to be_an(Array)
        expect(options.map { |opt| opt[:name] }).to include("All", "0-2: Low", "3-5: Medium", "6-8: High", "9-10: Legendary")
        expect(options.first).to include(id: 0, name: "All", start: 0, end: 10)
      end
    end

    describe '.by_potency_level_option' do
      it 'returns all potions for option id 0 (All)' do
        create(:potion, potency_level: 2)
        create(:potion, potency_level: 7)
        potions = Potion.by_potency_level_option(0)
        expect(potions.count).to eq(Potion.count)
      end

      it 'returns potions in the correct range for other options' do
        low = create(:potion, potency_level: 1)
        medium = create(:potion, potency_level: 4)
        high = create(:potion, potency_level: 7)
        legendary = create(:potion, potency_level: 10)

        expect(Potion.by_potency_level_option(1)).to include(low)
        expect(Potion.by_potency_level_option(1)).not_to include(medium, high, legendary)
        expect(Potion.by_potency_level_option(2)).to include(medium)
        expect(Potion.by_potency_level_option(3)).to include(high)
        expect(Potion.by_potency_level_option(4)).to include(legendary)
      end
    end

    describe '.sort_options' do
      it 'returns the correct sort options array' do
        options = Potion.sort_options
        expect(options).to be_an(Array)
        expect(options.map { |opt| opt[:name] }).to include("Default", "Name A -> Z", "Name Z -> A", "Potency Level 0 -> 9", "Potency Level 9 -> 0")
        expect(options.first).to include(id: 0, name: "Default", attr: :id, direction: :asc)
      end
    end

    describe '.sort_by_option' do
      it 'sorts by name ascending' do
        potion_a = create(:potion, name: "A Potion")
        potion_b = create(:potion, name: "B Potion")
        sorted = Potion.sort_by_option(1)
        expect(sorted.first).to eq(potion_a)
        expect(sorted.second).to eq(potion_b)
      end

      it 'sorts by name descending' do
        potion_a = create(:potion, name: "A Potion")
        potion_b = create(:potion, name: "B Potion")
        sorted = Potion.sort_by_option(2)
        expect(sorted.first).to eq(potion_b)
        expect(sorted.second).to eq(potion_a)
      end

      it 'sorts by potency_level ascending' do
        potion_low = create(:potion, potency_level: 1)
        potion_high = create(:potion, potency_level: 10)
        sorted = Potion.sort_by_option(3)
        expect(sorted.first).to eq(potion_low)
        expect(sorted.last).to eq(potion_high)
      end

      it 'sorts by potency_level descending' do
        potion_low = create(:potion, potency_level: 1)
        potion_high = create(:potion, potency_level: 10)
        sorted = Potion.sort_by_option(4)
        expect(sorted.first).to eq(potion_high)
        expect(sorted.last).to eq(potion_low)
      end
  end

  describe 'attribute validations' do
    it 'is valid with valid input' do
      potion = build(:potion)
      expect(potion).to be_valid
    end

    it 'is invalid without a name' do
      potion = build(:potion, name: nil)
      expect(potion).not_to be_valid
    end

    it 'is invalid without a description' do
      potion = build(:potion, description: nil)
      expect(potion).not_to be_valid
    end
    it 'is invalid without a effect' do
      potion = build(:potion, effect: nil)
      expect(potion).not_to be_valid
    end
    it 'is invalid without a potency_level' do
      potion = build(:potion, potency_level: nil)
      expect(potion).not_to be_valid
    end
    it 'is invalid without a image_url' do
      potion = build(:potion, image_url: nil)
      expect(potion).not_to be_valid
    end

    it 'is invalid with non-unique name' do
      create(:potion, name: 'Bob')
      new_potion = build(:potion, name: 'Bob', description: 'Hello', effect: 'something different', potency_level: 3, image_url: '123abc')
      expect(new_potion).not_to be_valid
    end

    it 'is invalid with case-insensitive name' do
      create(:potion, name: "Magic Jumping Beans")
      new_potion = build(:potion, name: "magic jumping beans")
      expect(new_potion).not_to be_valid
    end

    it 'is invalid with duplicate ingredients' do
      ingredient = create(:ingredient)
      potion = build(:potion)
      potion.potion_ingredients.build(ingredient_id: ingredient.id, quantity: 1)
      potion.potion_ingredients.build(ingredient_id: ingredient.id, quantity: 2)
      expect(potion).not_to be_valid
      expect(potion.errors[:potion_ingredients]).to include("can't have duplicate ingredients")
    end

  end

  describe '#display_image_url' do
    context "when potion's image_url is a web-hosted url" do
      it 'returns the url itself' do
        potion = build(:potion, image_url: 'https://www.google.com')

        url_for_image = potion.display_image_url

        expect(url_for_image).to eql('https://www.google.com')
      end
    end
    context "when potion's image_url is preloaded in the assets directory" do
      it 'returns the relative link to the image' do
        potion = build(:potion, image_url: "elixir_of_life.png")

        url_for_image = potion.display_image_url

        expect(url_for_image).to match(%r{\A/assets/elixir_of_life.*\.png\z})
      end
    end
    context "when the potion's image_url is neither a url nor a preloaded image" do
      it 'returns the placeholder url' do
        potion = build(:potion, image_url: "pancakes.gif")

        url_for_image = potion.display_image_url

        expect(url_for_image).to match(%r{\A/assets/potion_bottle_placeholder.*\.jpg\z})
      end
    end
  end

  describe "#ingredient_options" do
    it 'returns only non-associated ingredients' do
      ingredient1 = create(:ingredient)
      ingredient2 = create(:ingredient, name: 'Womandrake')
      ingredient3 = create(:ingredient, name: 'Handbrake')
      potion = create(:potion)
      create(:potion_ingredient, potion: potion, ingredient: ingredient1)
      potion_ingredient = create(:potion_ingredient, potion: potion, ingredient: ingredient2)

      potion.reload
      returned_ingredients = potion.ingredient_options(potion_ingredient)

      expect(returned_ingredients).to include(ingredient3)
      expect(returned_ingredients).to include(ingredient2)
      expect(returned_ingredients).not_to include(ingredient1)
    end
  end

  describe "#overall_rating" do
    it 'returns 0 for no reviews' do
      user = create(:user)
      potion = create(:potion, user: user)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to eql(0.00)
    end

    it 'averages the rating of one review' do
      user = create(:user)
      potion = create(:potion, user: user)
      create(:review, rating: 4, potion: potion, user: user)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to eql(4.00)
    end

    it 'averages the rating of four reviews' do
      user1 = create(:user)
      user2 = create(:user, username: 'Joe')
      user3 = create(:user, username: 'Bob')
      user4 = create(:user, username: 'Blob')
      potion = create(:potion, user: user1)
      create(:review, rating: 4, potion: potion, user: user1)
      create(:review, rating: 1, potion: potion, user: user2)
      create(:review, rating: 3, potion: potion, user: user3)
      create(:review, rating: 5, potion: potion, user: user4)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to eql(3.25)
    end

    it 'rounds the rating of three reviews' do
      user1 = create(:user)
      user2 = create(:user, username: 'Joe')
      user3 = create(:user, username: 'Bob')
      potion = create(:potion, user: user1)
      create(:review, rating: 2, potion: potion, user: user1)
      create(:review, rating: 3, potion: potion, user: user2)
      create(:review, rating: 5, potion: potion, user: user3)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to eql(3.33)
    end
  end
end

