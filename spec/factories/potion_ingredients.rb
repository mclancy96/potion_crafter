# frozen_string_literal: true

FactoryBot.define do
  factory :potion_ingredient do
    potion
    ingredient
    quantity { "1 handful" }
  end
end
