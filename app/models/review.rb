# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :potion

  validates :rating,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5 }

  scope :most_recent, ->(limit = 3) { order(created_at: :desc).limit(limit) }

  def rating_stars
    "⭐️" * rating
  end

  def formatted_created_at
    created_at.localtime.strftime("%b %d, %Y %I:%M %p")
  end

  def formatted_updated_at
    updated_at.localtime.strftime("%b %d, %Y %I:%M %p")
  end

  def edited?
    created_at != updated_at
  end
end
