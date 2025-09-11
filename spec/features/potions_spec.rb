require 'rails_helper'

RSpec.feature "Potions", type: :feature do
  before(:each) do
    user = create(:user)
    login_as(user)
  end

  scenario "User views the potions index" do
    potion = create(:potion)
    visit potions_path
    expect(page).to have_content(potion.name)
  end

  scenario "User creates a new potion" do
    visit new_potion_path
    fill_in "Name", with: "Magic Potion"
    fill_in "Description", with: "A powerful brew"
    fill_in "Effect", with: "Invisibility"
    fill_in "Potency level", with: 5
    fill_in "Image URL", with: "magic.png"
    click_button "Create Potion"
    expect(page).to have_content("Magic Potion")
  end
end
