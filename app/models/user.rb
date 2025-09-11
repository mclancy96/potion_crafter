# frozen_string_literal: true

class User < ApplicationRecord
  has_many :potions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_secure_password

  validates :username, :password, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 5, maximum: 36 }

  def used_ingredients
    Ingredient.joins(potions: :user).where(potions: { user_id: id }).distinct
  end
end
