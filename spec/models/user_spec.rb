# frozen_string_literal: true

require "rails_helper"

RSpec.describe User do
  describe "associations" do
    it { is_expected.to have_many(:potions).dependent(:destroy) }
    it { is_expected.to have_many(:reviews).dependent(:destroy) }
  end

  describe "password security" do
    it "requires a password and confirmation" do
      user = build(:user, password: "secret", password_confirmation: "secret")
      expect(user).to be_valid
    end

    it "is invalid if password and confirmation do not match" do
      user = build(:user, password: "secret", password_confirmation: "wrong")
      expect(user).not_to be_valid
    end

    it "authenticates with correct password" do
      user = create(:user, password: "secret", password_confirmation: "secret")
      expect(user.authenticate("secret")).to eq(user)
    end

    it "does not authenticate with incorrect password" do
      user = create(:user, password: "secret", password_confirmation: "secret")
      expect(user.authenticate("wrong")).to be_falsey
    end
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:username) }
    it { is_expected.to validate_presence_of(:password) }
    it { is_expected.to validate_uniqueness_of(:username).case_insensitive }
    it { is_expected.to validate_length_of(:password).is_at_least(5) }
    it { is_expected.to validate_length_of(:password).is_at_most(36) }
  end

  describe "attribute validations" do
    it "is valid with valid attributes" do
      user = build(:user)

      expect(user).to be_valid
    end

    it "is invalid without a username" do
      user = build(:user, username: nil)

      expect(user).not_to be_valid
    end

    it "is invalid without a password" do
      user = build(:user, password: nil)

      expect(user).not_to be_valid
    end

    it "is invalid with a short password" do
      user = build(:user, password: "abc")

      expect(user).not_to be_valid
    end

    it "is invalid with a long password" do
      user = build(:user, password: "abcabcabcabcabcabcabcabcabcabcabcabcabcabc")

      expect(user).not_to be_valid
    end
  end

  describe "#used_ingredients" do
    let(:user) { create(:user) }
    let(:other_user) { create(:user) }
    let(:ingredient1) { create(:ingredient) }
    let(:ingredient2) { create(:ingredient) }
    let(:ingredient3) { create(:ingredient) }
    let!(:potion1) { create(:potion, user: user) }
    let!(:potion2) { create(:potion, user: user) }
    let!(:potion3) { create(:potion, user: other_user) }
    let!(:pi1) { create(:potion_ingredient, potion: potion1, ingredient: ingredient1) }
    let!(:pi2) { create(:potion_ingredient, potion: potion2, ingredient: ingredient2) }
    let!(:pi3) { create(:potion_ingredient, potion: potion3, ingredient: ingredient3) }

    it "returns ingredients used in user potions" do
      expect(user.used_ingredients).to include(ingredient1, ingredient2)
    end

    it "does not return ingredients only used by other users" do
      expect(user.used_ingredients).not_to include(ingredient3)
    end

    it "returns unique ingredients only" do
      create(:potion_ingredient, potion: potion1, ingredient: ingredient2)
      expect(user.used_ingredients.where(id: ingredient2.id).count).to eq(1)
    end

    it "returns empty if user has no potions" do
      new_user = create(:user)
      expect(new_user.used_ingredients).to be_empty
    end
  end
end
