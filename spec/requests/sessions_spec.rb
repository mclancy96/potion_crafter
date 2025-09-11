require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  describe "POST /create" do
    it "logs in a user" do
      user = create(:user, password: 'password')
      post login_path, params: { user: { username: user.username, password: 'password' } }
      expect(response).to redirect_to(root_path)
    end
  end

  describe "DELETE /destroy" do
    let(:user) { create(:user, password: "password") }
    it "logs out a user" do
      login(user)
      get logout_path
      expect(response).to redirect_to(login_path)
    end
  end
end
