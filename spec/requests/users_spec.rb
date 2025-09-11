require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { create(:user, password: "password") }

  before(:each) do
    login(user)
  end
  describe "GET /index" do
    it "returns a successful response" do
      get user_path(user)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new user" do
      expect {
        post users_path, params: { user: { username: "newuser", password: "password", password_confirmation: "password" } }
      }.to change(User, :count).by(1)
      expect(response).to redirect_to(root_path)
    end
  end
end
