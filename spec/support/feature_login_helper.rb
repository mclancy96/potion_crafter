module LoginHelper
  def login_as(user)
    visit login_path
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Login"
  end
end

RSpec.configure do |config|
  config.include LoginHelper, type: :feature
end
