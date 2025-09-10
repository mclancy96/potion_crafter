# frozen_string_literal: true

FactoryBot.define do
  factory :ingredient do
    name { "Mandrake" }
    description { "A magical root" }
    rarity { 5 }
  end
end
