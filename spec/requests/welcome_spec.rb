require "rails_helper"

RSpec.describe "Welcome" do
  let(:user) { create(:user, password: "password") }

  before do
    login(user)
  end

  describe "GET /index" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
