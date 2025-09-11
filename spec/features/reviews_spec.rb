require 'rails_helper'

RSpec.feature "Reviews", type: :feature do
  before(:each) do
    user = create(:user)
    login_as(user)
  end

  scenario "User views the reviews index" do
    review = create(:review)
    visit potion_reviews_path(review.potion)
    expect(page).to have_content(review.comment)
  end

  scenario "User creates a new review" do
    user = User.last
    potion = create(:potion, user: user)
    visit potion_reviews_path(potion)
    fill_in "Rating", with: 5
    fill_in "Comment", with: "Amazing!"
    click_button "Create Review"
    expect(page).to have_content("Amazing!")
  end
end
