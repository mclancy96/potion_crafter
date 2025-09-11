require 'rails_helper'

RSpec.describe "Welcome", type: :request do
  let(:user) { create(:user, password: "password") }

  before(:each) do
    login(user)
  end
  describe "GET /index" do
    it "returns a successful response" do
      get root_path
      expect(response).to have_http_status(:success)
    end
  end
end
