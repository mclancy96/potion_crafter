require 'rails_helper'

RSpec.describe "Ingredients", type: :request do
  let(:user) { create(:user, password: "password") }

  before(:each) do
    login(user)
  end
  describe "GET /index" do
    it "returns a successful response" do
      get ingredients_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new ingredient" do
      expect {
        post ingredients_path, params: { ingredient: { name: "Mandrake", description: "A magical root", rarity: 5 } }
      }.to change(Ingredient, :count).by(1)
      expect(response).to redirect_to(ingredient_path(Ingredient.last))
    end
  end
end
