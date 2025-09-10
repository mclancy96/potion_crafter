# frozen_string_literal: true

FactoryBot.define do
  factory :potion do
    sequence(:name) { |n| "potion#{n}" }
    description { "A magical jumping bean" }
    user
    effect { 'Makes you jump' }
    potency_level { 9 }
    image_url { 'abc123' }
  end
end
