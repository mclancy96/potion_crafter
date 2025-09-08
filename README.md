# Potion Crafter

## ERD

[ERD Source](https://dbdiagram.io/d/Potion-Crafter-68bed1e161a46d388efbb802)

```text
User
 ├── has_many :potions
 ├── has_many :reviews
 └── has_many :ingredients, through: :potions

Potion
 ├── belongs_to :user
 ├── has_many :potion_ingredients
 ├── has_many :ingredients, through: :potion_ingredients
 └── has_many :reviews

Ingredient
 └── has_many :potions, through: :potion_ingredients

PotionIngredient
 ├── belongs_to :potion
 └── belongs_to :ingredient

Review
 ├── belongs_to :user
 └── belongs_to :potion
```
