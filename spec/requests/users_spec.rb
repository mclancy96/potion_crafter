require "rails_helper"

RSpec.describe "Users" do
  let(:user) { create(:user, password: "password") }

  before do
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
      expect do
        post users_path,
             params: { user: { username: "newuser", password: "password", password_confirmation: "password" } }
      end.to change(User, :count).by(1)
      expect(response).to redirect_to(root_path)
    end
  end
end
