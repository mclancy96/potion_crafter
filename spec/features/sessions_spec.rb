require 'rails_helper'

RSpec.feature "Sessions", type: :feature do
  scenario "User logs in" do
    user = create(:user, password: 'password')
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    click_button "Login"
    expect(page).to have_content("Greetings")
  end

  scenario "User logs out" do
    user = create(:user, password: 'password')
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: "password"
    click_button "Login"
    click_link "Log Out"
    expect(page).to have_content("Log In")
  end
end
