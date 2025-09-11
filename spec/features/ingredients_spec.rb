require 'rails_helper'

RSpec.feature "Ingredients", type: :feature do
  before(:each) do
    user = create(:user)
    login_as(user)
  end
  
  scenario "User views the ingredients index" do
    ingredient = create(:ingredient)
    visit ingredients_path
    expect(page).to have_content(ingredient.name)
  end

  scenario "User creates a new ingredient" do
    visit new_ingredient_path
    fill_in "Name", with: "Mandrake"
    fill_in "Description", with: "A magical root"
    fill_in "Rarity", with: 5
    click_button "Create Ingredient"
    expect(page).to have_content("Mandrake")
  end
end
