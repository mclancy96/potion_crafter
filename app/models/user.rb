# frozen_string_literal: true

class User < ApplicationRecord
  has_many :potions
  has_many :reviews
  has_secure_password

  validates :username, :password, presence: true
  validates :username, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 5, maximum: 36 }
end
