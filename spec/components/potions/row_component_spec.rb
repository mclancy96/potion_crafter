require "rails_helper"

RSpec.describe Potions::RowComponent, type: :component do
  include ViewComponent::TestHelpers

  let(:owner)  { create(:user) }
  let(:other)  { create(:user) }
  let(:potion) { create(:potion, user: owner) }
  let(:owner_result) { render_inline(described_class.new(potion: potion, current_user: owner)) }
  let(:other_result) { render_inline(described_class.new(potion: potion, current_user: other)) }

  context "when current_user is the potion owner" do
    it "renders potion name and owner username" do
      expect(owner_result.css("a").map(&:text)).to include(potion.name, potion.user.username)
    end

    it "renders potion description and potency level" do
      expect(owner_result.text).to include(potion.description, "#{potion.potency_level} / 10")
    end

    it "renders enabled edit button" do
      expect(owner_result.css("form").any? { |f| f.text.include?("Edit") }).to be true
    end

    it "renders enabled delete button" do
      expect(owner_result.css("form").any? { |f| f.text.include?("Delete") }).to be true
    end

    it "renders no disabled buttons" do
      expect(owner_result.css("button[disabled]").count).to eq 0
    end
  end

  context "when current_user is NOT the potion owner" do
    it "renders potion name and owner username" do
      expect(other_result.css("a").map(&:text)).to include(potion.name, potion.user.username)
    end

    it "renders potion description and potency level" do
      expect(other_result.text).to include(potion.description, "#{potion.potency_level} / 10")
    end

    it "renders two disabled buttons" do
      expect(other_result.css("button[disabled]").count).to eq 2
    end

    it "includes a disabled edit button" do
      disabled_texts = other_result.css("button[disabled]").map(&:text)

      expect(disabled_texts).to include("Edit")
    end

    it "includes a disabled delete button" do
      disabled_texts = other_result.css("button[disabled]").map(&:text)
      expect(disabled_texts).to include("Delete")
    end

    it "doesn't include an edit form" do
      expect(other_result.css("form").any? { |f| f.text.include?("Edit") }).to be false
    end

    it "doesn't include a delete form" do
      expect(other_result.css("form").any? { |f| f.text.include?("Delete") }).to be false
    end
  end
end
