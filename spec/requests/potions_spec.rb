require "rails_helper"

RSpec.describe "Potions" do
  let(:user) { create(:user, password: "password") }

  before do
    login(user)
  end

  describe "GET /index" do
    it "returns a successful response" do
      get potions_path
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /create" do
    it "creates a new potion" do
      user = create(:user)
      expect do
        post potions_path,
             params: { potion: { name: "Magic Potion", description: "A powerful brew", effect: "Invisibility", potency_level: 5,
                                 image_url: "magic.png", user_id: user.id } }
      end.to change(Potion, :count).by(1)
      expect(response).to redirect_to(potion_path(Potion.last))
    end
  end
end
