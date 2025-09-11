require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { create(:user, password: "password") }
  let(:potion) { create(:potion) }

  before(:each) do
    login(user)
    create(:review, potion: potion)
  end
  describe "GET /index" do
    it "returns a successful response" do
      get potion_reviews_path(potion)
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new review" do
      expect {
        post potion_reviews_path(potion), params: { review: { rating: 5, comment: "Amazing!"}, user_id: user.id, id: potion.id  }
      }.to change(Review, :count).by(1)
      expect(response).to redirect_to(potion_reviews_path(potion))
    end
  end
end
