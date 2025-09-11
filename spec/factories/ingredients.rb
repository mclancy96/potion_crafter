# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    sequence(:name) { |n| "ingredient#{n}" }
    description { "A magical root" }
    rarity { 5 }
  end
end
