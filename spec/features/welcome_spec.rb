require "rails_helper"

RSpec.feature "Welcome" do
  scenario "User visits the home page" do
    visit root_path
    expect(page).to have_content("Welcome")
  end
end
