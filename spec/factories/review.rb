# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    potion
    user
    comment { 'It works great' }
    rating { 5 }
  end
end
