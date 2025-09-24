require "rails_helper"

RSpec.describe Potions::TableComponent, type: :component do
  include ViewComponent::TestHelpers

  let(:owner)    { create(:user) }
  let(:other)    { create(:user) }
  let!(:potion_a) { create(:potion, name: "Potion A", user: owner) }
  let!(:potion_b) { create(:potion, name: "Potion B", user: owner) }
  let(:potions) { [potion_a, potion_b] }

  context "when current_user is the owner" do
    it "renders a table wrapper" do
      result = render_inline(described_class.new(potions: potions, current_user: owner))

      expect(result.css("table").count).to eq(1)
    end

    it "renders rows for each potion" do
      result = render_inline(described_class.new(potions: potions, current_user: owner))

      expect(result.css("tbody tr").length).to eq(potions.length)
    end

    it "includes potion names in the rows" do
      result = render_inline(described_class.new(potions: potions, current_user: owner))
      names = result.css("tbody tr td a").map(&:text)

      expect(names).to include(potion_a.name, potion_b.name)
    end

    it "renders Edit forms for each owner row" do
      result = render_inline(described_class.new(potions: potions, current_user: owner))

      expect(result.css("tbody tr").all? { |tr| tr.css("form").any? { |f| f.text.include?("Edit") } }).to be true
    end

    it "renders Delete forms for each owner row" do
      result = render_inline(described_class.new(potions: potions, current_user: owner))

      expect(result.css("tbody tr").all? { |tr| tr.css("form").any? { |f| f.text.include?("Delete") } }).to be true
    end
  end

  context "when current_user is not the owner" do
    it "renders rows for each potion" do
      result = render_inline(described_class.new(potions: potions, current_user: other))

      expect(result.css("tbody tr").length).to eq(potions.length)
    end

    it "includes a disabled Edit button" do
      result = render_inline(described_class.new(potions: potions, current_user: other))
      disabled_buttons = result.css("button[disabled]").map(&:text)

      expect(disabled_buttons).to include("Edit")
    end

    it "includes a disabled Delete button" do
      result = render_inline(described_class.new(potions: potions, current_user: other))
      disabled_buttons = result.css("button[disabled]").map(&:text)

      expect(disabled_buttons).to include("Delete")
    end

    it "does not render form-based Edit actions" do
      result = render_inline(described_class.new(potions: potions, current_user: other))

      expect(result.css("tbody tr").any? { |tr| tr.css("form").any? { |f| f.text.include?("Edit") } }).to be false
    end

    it "does not render form-based Delete actions" do
      result = render_inline(described_class.new(potions: potions, current_user: other))

      expect(result.css("tbody tr").any? { |tr| tr.css("form").any? { |f| f.text.include?("Delete") } }).to be false
    end
  end
end
