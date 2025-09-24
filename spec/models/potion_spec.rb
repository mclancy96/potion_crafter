# frozen_string_literal: true

require "rails_helper"

RSpec.describe Potion do
  describe "associations" do
    it { is_expected.to have_many(:potion_ingredients) }
    it { is_expected.to have_many(:ingredients).through(:potion_ingredients) }
    it { is_expected.to have_many(:reviews) }
    it { is_expected.to belong_to(:user) }
  end

  describe "validations" do
    subject { create(:potion) }

    it { is_expected.to validate_presence_of :name }
    it { is_expected.to validate_uniqueness_of(:name).case_insensitive }
    it { is_expected.to validate_presence_of :description }
    it { is_expected.to validate_presence_of :effect }
    it { is_expected.to validate_presence_of :potency_level }
    it { is_expected.to validate_numericality_of(:potency_level).is_greater_than_or_equal_to(1) }
    it { is_expected.to validate_numericality_of(:potency_level).is_less_than_or_equal_to(10) }
    it { is_expected.to validate_numericality_of(:potency_level).only_integer }
    it { is_expected.to validate_presence_of :image_url }
  end

  describe "nested attributes" do
    it "accepts valid nested potion_ingredients attributes" do
      ingredient = create(:ingredient)
      user = create(:user)
      potion = described_class.new(
        name: "Test Potion",
        description: "desc",
        effect: "effect",
        potency_level: 5,
        image_url: "img.png",
        user: user,
        potion_ingredients_attributes: [
          { ingredient_id: ingredient.id, quantity: 2 },
        ]
      )
      expect(potion).to be_valid
      potion.save
      expect(potion.potion_ingredients.count).to eq(1)
    end

    it "rejects nested potion_ingredients with blank ingredient_id or quantity" do
      user = create(:user)
      potion = described_class.new(
        name: "Test Potion",
        description: "desc",
        effect: "effect",
        potency_level: 5,
        image_url: "img.png",
        user: user,
        potion_ingredients_attributes: [
          { ingredient_id: nil, quantity: 2 },
          { ingredient_id: 1, quantity: nil },
        ]
      )
      potion.save
      expect(potion.potion_ingredients).to be_empty
    end
  end

  describe ".potency_level_options" do
    it "returns the correct options array" do
      options = described_class.potency_level_options
      expect(options).to be_an(Array)
      expect(options.pluck(:name)).to include("All", "0-2: Low", "3-5: Medium", "6-8: High", "9-10: Legendary")
      expect(options.first).to include(id: 0, name: "All", start: 0, end: 10)
    end
  end

  describe ".by_potency_level_option" do
    it "returns all potions for option id 0 (All)" do
      create(:potion, potency_level: 2)
      create(:potion, potency_level: 7)
      potions = described_class.by_potency_level_option(0)
      expect(potions.count).to eq(described_class.count)
    end

    it "returns potions in the correct range for other options" do
      low = create(:potion, potency_level: 1)
      medium = create(:potion, potency_level: 4)
      high = create(:potion, potency_level: 7)
      legendary = create(:potion, potency_level: 10)

      expect(described_class.by_potency_level_option(1)).to include(low)
      expect(described_class.by_potency_level_option(1)).not_to include(medium, high, legendary)
      expect(described_class.by_potency_level_option(2)).to include(medium)
      expect(described_class.by_potency_level_option(3)).to include(high)
      expect(described_class.by_potency_level_option(4)).to include(legendary)
    end
  end

  describe ".sort_options" do
    it "returns the correct sort options array" do
      options = described_class.sort_options
      expect(options).to be_an(Array)
      expect(options.pluck(:name)).to include("Default", "Name A -> Z", "Name Z -> A", "Potency Level 0 -> 9",
                                              "Potency Level 9 -> 0")
      expect(options.first).to include(id: 0, name: "Default", attr: :id, direction: :asc)
    end
  end

  describe ".sort_by_option" do
    it "sorts by name ascending" do
      potion_a = create(:potion, name: "A Potion")
      potion_b = create(:potion, name: "B Potion")
      sorted = described_class.sort_by_option(1)
      expect(sorted.first).to eq(potion_a)
      expect(sorted.second).to eq(potion_b)
    end

    it "sorts by name descending" do
      potion_a = create(:potion, name: "A Potion")
      potion_b = create(:potion, name: "B Potion")
      sorted = described_class.sort_by_option(2)
      expect(sorted.first).to eq(potion_b)
      expect(sorted.second).to eq(potion_a)
    end

    it "sorts by potency_level ascending" do
      potion_low = create(:potion, potency_level: 1)
      potion_high = create(:potion, potency_level: 10)
      sorted = described_class.sort_by_option(3)
      expect(sorted.first).to eq(potion_low)
      expect(sorted.last).to eq(potion_high)
    end

    it "sorts by potency_level descending" do
      potion_low = create(:potion, potency_level: 1)
      potion_high = create(:potion, potency_level: 10)
      sorted = described_class.sort_by_option(4)
      expect(sorted.first).to eq(potion_high)
      expect(sorted.last).to eq(potion_low)
    end
  end

  describe "attribute validations" do
    it "is valid with valid input" do
      potion = build(:potion)
      expect(potion).to be_valid
    end

    it "is invalid without a name" do
      potion = build(:potion, name: nil)
      expect(potion).not_to be_valid
    end

    it "is invalid without a description" do
      potion = build(:potion, description: nil)
      expect(potion).not_to be_valid
    end

    it "is invalid without a effect" do
      potion = build(:potion, effect: nil)
      expect(potion).not_to be_valid
    end

    it "is invalid without a potency_level" do
      potion = build(:potion, potency_level: nil)
      expect(potion).not_to be_valid
    end

    it "is invalid without a image_url" do
      potion = build(:potion, image_url: nil)
      expect(potion).not_to be_valid
    end

    it "is invalid with non-unique name" do
      create(:potion, name: "Bob")
      new_potion = build(:potion, name: "Bob", description: "Hello", effect: "something different", potency_level: 3,
                                  image_url: "123abc")
      expect(new_potion).not_to be_valid
    end

    it "is invalid with case-insensitive name" do
      create(:potion, name: "Magic Jumping Beans")
      new_potion = build(:potion, name: "magic jumping beans")
      expect(new_potion).not_to be_valid
    end

    it "is invalid with duplicate ingredients" do
      ingredient = create(:ingredient)
      potion = build(:potion)
      potion.potion_ingredients.build(ingredient_id: ingredient.id, quantity: 1)
      potion.potion_ingredients.build(ingredient_id: ingredient.id, quantity: 2)
      expect(potion).not_to be_valid
      expect(potion.errors[:potion_ingredients]).to include("can't have duplicate ingredients")
    end
  end

  describe "#display_image_url" do
    context "when potion's image_url is a web-hosted url" do
      it "returns the url itself" do
        potion = build(:potion, image_url: "https://www.google.com")

        url_for_image = potion.display_image_url

        expect(url_for_image).to eql("https://www.google.com")
      end
    end

    context "when potion's image_url is preloaded in the assets directory" do
      it "returns the relative link to the image" do
        potion = build(:potion, image_url: "elixir_of_life.png")

        url_for_image = potion.display_image_url

        expect(url_for_image).to match(%r{\A/assets/elixir_of_life.*\.png\z})
      end
    end

    context "when the potion's image_url is neither a url nor a preloaded image" do
      it "returns the placeholder url" do
        potion = build(:potion, image_url: "pancakes.gif")

        url_for_image = potion.display_image_url

        expect(url_for_image).to match(%r{\A/assets/potion_bottle_placeholder.*\.jpg\z})
      end
    end
  end

  describe "#ingredient_options" do
    it "returns only non-associated ingredients" do
      ingredient1 = create(:ingredient)
      ingredient2 = create(:ingredient, name: "Womandrake")
      ingredient3 = create(:ingredient, name: "Handbrake")
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
    it "returns 0 for no reviews" do
      user = create(:user)
      potion = create(:potion, user: user)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to be_within(0.01).of(0.0)
    end

    it "averages the rating of one review" do
      user = create(:user)
      potion = create(:potion, user: user)
      create(:review, rating: 4, potion: potion, user: user)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to be_within(0.01).of(4.0)
    end

    it "averages the rating of four reviews" do
      user1 = create(:user)
      user2 = create(:user, username: "Joe")
      user3 = create(:user, username: "Bob")
      user4 = create(:user, username: "Blob")
      potion = create(:potion, user: user1)
      create(:review, rating: 4, potion: potion, user: user1)
      create(:review, rating: 1, potion: potion, user: user2)
      create(:review, rating: 3, potion: potion, user: user3)
      create(:review, rating: 5, potion: potion, user: user4)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to be_within(0.01).of(3.25)
    end

    it "rounds the rating of three reviews" do
      user1 = create(:user)
      user2 = create(:user, username: "Joe")
      user3 = create(:user, username: "Bob")
      potion = create(:potion, user: user1)
      create(:review, rating: 2, potion: potion, user: user1)
      create(:review, rating: 3, potion: potion, user: user2)
      create(:review, rating: 5, potion: potion, user: user3)

      potion.reload
      average_rating = potion.overall_rating

      expect(average_rating).to be_within(0.01).of(3.33)
    end
  end

  describe "#potency_level_short_name" do
    it "returns Low for potency_level 1" do
      potion = build(:potion, potency_level: 1)
      expect(potion.potency_level_short_name).to eq("Low")
    end

    it "returns Medium for potency_level 4" do
      potion = build(:potion, potency_level: 4)
      expect(potion.potency_level_short_name).to eq("Medium")
    end

    it "returns High for potency_level 7" do
      potion = build(:potion, potency_level: 7)
      expect(potion.potency_level_short_name).to eq("High")
    end

    it "returns Legendary for potency_level 10" do
      potion = build(:potion, potency_level: 10)
      expect(potion.potency_level_short_name).to eq("Legendary")
    end

    it "returns Unknown for out-of-range potency_level" do
      potion = build(:potion, potency_level: 11)
      expect(potion.potency_level_short_name).to eq("Unknown")
    end
  end

  describe "#potency_level_badge_color" do
    it "returns secondary for Low" do
      potion = build(:potion, potency_level: 1)
      expect(potion.potency_level_badge_color).to eq("secondary")
    end

    it "returns info for Medium" do
      potion = build(:potion, potency_level: 4)
      expect(potion.potency_level_badge_color).to eq("info")
    end

    it "returns warning for High" do
      potion = build(:potion, potency_level: 7)
      expect(potion.potency_level_badge_color).to eq("warning")
    end

    it "returns danger for Legendary" do
      potion = build(:potion, potency_level: 10)
      expect(potion.potency_level_badge_color).to eq("danger")
    end

    it "returns primary for out-of-range" do
      potion = build(:potion, potency_level: 11)
      expect(potion.potency_level_badge_color).to eq("primary")
    end
  end

  describe "#overall_rating_badge_color" do
    it "returns success for rating 5" do
      potion = build(:potion)
      allow(potion).to receive(:overall_rating).and_return(5)
      expect(potion.overall_rating_badge_color).to eq("success")
    end

    it "returns info for rating 4" do
      potion = build(:potion)
      allow(potion).to receive(:overall_rating).and_return(4)
      expect(potion.overall_rating_badge_color).to eq("info")
    end

    it "returns warning for rating 3" do
      potion = build(:potion)
      allow(potion).to receive(:overall_rating).and_return(3)
      expect(potion.overall_rating_badge_color).to eq("warning")
    end

    it "returns danger for rating 2" do
      potion = build(:potion)
      allow(potion).to receive(:overall_rating).and_return(2)
      expect(potion.overall_rating_badge_color).to eq("danger")
    end

    it "returns secondary for rating 0" do
      potion = build(:potion)
      allow(potion).to receive(:overall_rating).and_return(0)
      expect(potion.overall_rating_badge_color).to eq("secondary")
    end
  end
end
