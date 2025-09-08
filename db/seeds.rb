# frozen_string_literal: true

# Clear existing data
User.destroy_all
Ingredient.destroy_all
Potion.destroy_all
PotionIngredient.destroy_all
Review.destroy_all

puts 'Creating users...'
# Create Users
users = []
20.times do |i|
  users << User.create!(
    username: "wizard#{i + 1}",
    email: "wizard#{i + 1}@potioncraft.com",
    password_digest: BCrypt::Password.create('password123')
  )
end

puts 'Creating ingredients...'
# Create Ingredients with realistic potion ingredient names
ingredient_data = [
  { name: "Dragon's Blood",
    description: 'Rare crimson liquid extracted from ancient dragons. Provides immense power to any potion.', rarity: 5 },
  { name: 'Moonstone Powder',
    description: 'Finely ground moonstone that glows with ethereal light. Enhances magical properties.', rarity: 4 },
  { name: 'Phoenix Feather',
    description: 'A single feather from the legendary phoenix. Grants regenerative abilities.', rarity: 5 },
  { name: 'Unicorn Hair',
    description: "Silky white hair from a unicorn's mane. Known for its purity and healing properties.", rarity: 4 },
  { name: 'Nightshade Berries',
    description: 'Dark purple berries that grow only in moonlight. Highly toxic but magically potent.', rarity: 3 },
  { name: 'Crystal Cave Water',
    description: 'Pure water collected from deep crystal caves. Amplifies other ingredients.', rarity: 2 },
  { name: 'Golden Apple Extract',
    description: 'Concentrated essence from golden apples of immortality. Grants longevity.', rarity: 4 },
  { name: 'Troll Moss', description: 'Thick green moss that grows on troll backs. Provides strength and endurance.',
    rarity: 2 },
  { name: 'Fairy Dust', description: 'Shimmering powder left by fairy wings. Enables flight and lightness.',
    rarity: 3 },
  { name: 'Spider Silk',
    description: 'Strong silken threads from giant cave spiders. Used for binding and flexibility.', rarity: 1 },
  { name: 'Basilisk Venom', description: 'Deadly poison from the king of serpents. Extremely dangerous but powerful.',
    rarity: 5 },
  { name: 'Mandrake Root', description: 'Screaming root that must be harvested carefully. Provides mental clarity.',
    rarity: 3 },
  { name: 'Liquid Starlight', description: 'Captured light from fallen stars. Illuminates and purifies.', rarity: 4 },
  { name: 'Goblin Spit', description: 'Acidic saliva from cave goblins. Useful for dissolving other ingredients.',
    rarity: 1 },
  { name: 'Mermaid Scales', description: 'Iridescent scales from deep sea mermaids. Grants underwater abilities.',
    rarity: 3 },
  { name: 'Ancient Tree Bark', description: 'Bark from thousand-year-old oak trees. Provides wisdom and longevity.',
    rarity: 2 },
  { name: 'Demon Horn Powder', description: 'Ground horn from lesser demons. Grants temporary supernatural strength.',
    rarity: 4 },
  { name: 'Celestial Honey', description: 'Sweet nectar produced by star bees. Heals and energizes.', rarity: 3 },
  { name: 'Ghost Essence', description: 'Ectoplasmic residue from restless spirits. Enables invisibility.', rarity: 3 },
  { name: 'Volcano Ash', description: 'Fine ash from active volcanic eruptions. Provides explosive energy.',
    rarity: 2 },
  { name: 'Ice Dragon Breath', description: 'Crystallized breath weapon from ice dragons. Creates freezing effects.',
    rarity: 5 },
  { name: "Witch's Herb", description: 'Common herb cultivated by hedge witches. Mild but reliable effects.',
    rarity: 1 },
  { name: 'Kraken Ink', description: 'Dark ink sac from giant sea krakens. Clouds vision and confuses enemies.',
    rarity: 4 },
  { name: 'Lightning in a Bottle', description: 'Captured electrical essence from storms. Provides speed and energy.',
    rarity: 4 },
  { name: 'Mushroom Spores', description: 'Spores from magical forest mushrooms. Causes hallucinations and visions.',
    rarity: 2 }
]

ingredients = ingredient_data.map do |data|
  Ingredient.create!(data)
end

puts 'Creating potions...'
# Create Potions
potion_data = [
  { name: 'Elixir of Life', description: 'A legendary potion that grants eternal youth and vitality.',
    effect: 'Immortality', potency_level: 10 },
  { name: 'Potion of Fire Immunity', description: 'Protects the drinker from all forms of fire and heat damage.',
    effect: 'Fire Protection', potency_level: 8 },
  { name: 'Invisibility Draught', description: 'Renders the drinker completely invisible for several hours.',
    effect: 'Invisibility', potency_level: 7 },
  { name: 'Strength of Giants', description: 'Temporarily grants the physical power of mountain giants.',
    effect: 'Super Strength', potency_level: 9 },
  { name: 'Healing Potion', description: 'Rapidly heals wounds and restores health to the body.', effect: 'Healing',
    potency_level: 5 },
  { name: 'Potion of Levitation', description: 'Allows the drinker to float and fly through the air.',
    effect: 'Flight', potency_level: 6 },
  { name: 'Mind Reading Elixir', description: 'Grants temporary telepathic abilities to read thoughts.',
    effect: 'Telepathy', potency_level: 8 },
  { name: 'Potion of Speed', description: 'Dramatically increases movement and reaction speed.', effect: 'Super Speed',
    potency_level: 7 },
  { name: 'Truth Serum', description: 'Forces the drinker to speak only the truth.', effect: 'Truth Telling',
    potency_level: 6 },
  { name: 'Potion of Night Vision', description: 'Allows perfect vision in complete darkness.', effect: 'Night Vision',
    potency_level: 4 },
  { name: 'Liquid Courage', description: "Removes all fear and doubt from the drinker's mind.", effect: 'Fearlessness',
    potency_level: 5 },
  { name: 'Potion of Polymorphing', description: 'Transforms the drinker into any animal for a limited time.',
    effect: 'Shape Shifting', potency_level: 9 },
  { name: 'Elixir of Wisdom', description: 'Temporarily enhances intelligence and magical knowledge.',
    effect: 'Intelligence Boost', potency_level: 7 },
  { name: 'Potion of Water Breathing', description: 'Allows breathing underwater like a fish.',
    effect: 'Underwater Breathing', potency_level: 6 },
  { name: 'Love Potion', description: 'Creates intense romantic attraction in the drinker.', effect: 'Charm',
    potency_level: 5 },
  { name: 'Potion of Stone Skin', description: 'Hardens the skin to be as tough as granite.',
    effect: 'Damage Resistance', potency_level: 8 },
  { name: 'Elixir of Youth', description: 'Reverses aging by 10-20 years temporarily.', effect: 'Age Reversal',
    potency_level: 8 },
  { name: 'Potion of Giant Growth', description: "Increases the drinker's size to three times normal.",
    effect: 'Size Increase', potency_level: 7 },
  { name: 'Sleeping Draught', description: 'Induces deep, peaceful sleep for exactly 8 hours.', effect: 'Sleep',
    potency_level: 3 },
  { name: 'Potion of Luck', description: 'Greatly improves fortune and success in all endeavors.',
    effect: 'Luck Enhancement', potency_level: 6 },
  { name: 'Antidote Supreme', description: 'Neutralizes any poison or toxin in the body.', effect: 'Poison Cure',
    potency_level: 9 },
  { name: 'Potion of Time Dilation', description: 'Slows down time perception for the drinker.',
    effect: 'Time Manipulation', potency_level: 10 },
  { name: 'Elixir of Charisma', description: 'Makes the drinker irresistibly charming and persuasive.',
    effect: 'Charisma Boost', potency_level: 6 },
  { name: 'Potion of Perfect Memory', description: 'Grants photographic memory for 24 hours.',
    effect: 'Memory Enhancement', potency_level: 7 },
  { name: "Berserker's Brew", description: 'Sends the drinker into a controlled battle rage.', effect: 'Battle Fury',
    potency_level: 8 }
]

potions = potion_data.map do |data|
  Potion.create!(
    name: data[:name],
    description: data[:description],
    user: users.sample,
    effect: data[:effect],
    potency_level: data[:potency_level]
  )
end

puts 'Creating potion ingredients relationships...'
# Create PotionIngredients (many-to-many relationships)
quantities = ['1 drop', '2 drops', '3 drops', '1 pinch', '2 pinches', '1 handful', '1 cup', '2 cups', '1 vial',
              '2 vials', '1 ounce', '3 ounces']

potions.each do |potion|
  # Each potion has 3-7 ingredients
  num_ingredients = rand(3..7)
  selected_ingredients = ingredients.sample(num_ingredients)

  selected_ingredients.each do |ingredient|
    PotionIngredient.create!(
      ingredient: ingredient,
      potion: potion,
      quantity: quantities.sample
    )
  end
end

puts 'Creating reviews...'
# Create Reviews
review_comments = [
  'Absolutely incredible! This potion exceeded all my expectations.',
  'Worked perfectly as described. Will definitely buy again.',
  'A bit too strong for my liking, but very effective.',
  'The effects wore off too quickly for the price.',
  'Amazing craftsmanship! You can tell this was made by an expert.',
  'Had some minor side effects, but overall satisfied.',
  "Best potion I've ever tried! Highly recommend to everyone.",
  'Good quality but took longer to work than expected.',
  'Perfect for beginners. Gentle but noticeable effects.',
  'Not worth the rare ingredients used. Expected more.',
  'Incredible potency! A little goes a very long way.',
  'The taste is awful but the effects are worth it.',
  'Exactly what I needed for my quest. Saved my life!',
  'Too expensive for what you get. Better options available.',
  'Remarkable results! This crafter really knows their stuff.',
  'Mild effects but very safe to use. Good for daily consumption.',
  'Powerful but dangerous. Use with extreme caution.',
  'Perfect balance of ingredients. Shows real skill.',
  'The effects lasted much longer than advertised.',
  'Great for special occasions but not everyday use.',
  'Transformed my entire approach to potion making.',
  'Simple but effective. Sometimes the classics are best.',
  'Revolutionary formula! This will change everything.',
  'Decent potion but nothing special. Average quality.',
  "Extraordinary! I've never experienced anything like it."
]

# Create 100 reviews
100.times do
  Review.create!(
    user: users.sample,
    potion: potions.sample,
    rating: rand(1..5),
    comment: review_comments.sample
  )
end

puts 'Seeding complete!'
puts 'Created:'
puts "- #{User.count} users"
puts "- #{Ingredient.count} ingredients"
puts "- #{Potion.count} potions"
puts "- #{PotionIngredient.count} potion-ingredient relationships"
puts "- #{Review.count} reviews"
