# Potion Crafter

Potion Crafter is a full-stack Rails web application simulating a magical potion brewing community for witches. Users can create, manage, and review potions, add ingredients, and interact with other potion crafters. The app features authentication, nested resources, sorting/filtering, and robust validation.

## Features

- User authentication (sign up, log in, log out)
- Create, edit, and delete potions
- Add ingredients to potions (with quantity)
- View all potions and potion details
- Leave reviews (rating & comment) on potions
- Filter and sort potions by potency level and other attributes
- Error handling with clear messages and preserved form inputs
- View all ingredients and potions using a specific ingredient
- Stretch goals: user profiles, private potions, seasonal features, achievements

## User Stories

See [`user-stories.md`](./user-stories.md) for a full list of user stories and planned features.

## Entity Relationship Diagram (ERD)

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

## Installation & Setup

### Prerequisites

- Ruby 3.3.5
- Rails 8.x
- SQLite3 (default, can be swapped for Postgres)

### 1. Clone the repository

```sh
git clone https://github.com/mclancy96/potion_crafter.git
cd potion_crafter
```

### 2. Install dependencies

```sh
bundle install
```

### 3. Set up the database

```sh
bin/rails db:create db:migrate db:seed
```

### 4. Start the Rails server

```sh
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000) in your browser.

### 5. Run the test suite

```sh
bundle exec rspec
```

## Configuration

App configuration files are in the `config/` directory. See `config/database.yml` for database settings and `config/environments/` for environment-specific configs.

## Development Tools

- RSpec & FactoryBot for testing
- Shoulda-matchers for model specs
- Capybara & Selenium for integration/system tests
- Rubocop for linting
- Brakeman for security

## Contributing

Pull requests and issues are welcome! See the user stories for ideas on features and improvements.

## License

MIT
