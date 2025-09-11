module RequestLoginHelper
  def login(user)
    post login_path, params: { user: { username: user.username, password: user.password } }
  end
end

RSpec.configure do |config|
  config.include RequestLoginHelper, type: :request
end
