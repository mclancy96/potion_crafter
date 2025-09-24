require "rails_helper"

RSpec.feature "Users" do
  before do
    user = create(:user)
    login_as(user)
  end

  scenario "User views a user show page" do
    user = User.last
    visit user_path(user)
    expect(page).to have_content(user.username)
  end
end
