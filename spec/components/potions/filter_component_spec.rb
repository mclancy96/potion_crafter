require "rails_helper"

RSpec.describe Potions::FilterComponent, type: :component do
  include ViewComponent::TestHelpers

  context "when the filter is in default view" do
    let(:default_filter) { render_inline(described_class.new(selected_filter: 0, selected_sort: 0)) }

    it "displays 'All' for potency level" do
      expect(default_filter.css("select#filter_potency_level option[selected]").text).to eq("All")
    end

    it "displays 'Default' for sort option" do
      expect(default_filter.css("select#sort_potion_method option[selected='selected']").text).to eq("Default")
    end

    it "displays all expected filter options" do
      expect(default_filter.css("select#filter_potency_level option").text).to include("All",
                                                                                       "0-2: Low",
                                                                                       "3-5: Medium",
                                                                                       "6-8: High",
                                                                                       "9-10: Legendary")
    end

    it "displays all expected sort options" do
      expect(default_filter.css("select#sort_potion_method option").text).to include("Default",
                                                                                     "Name A -> Z",
                                                                                     "Name Z -> A",
                                                                                     "Potency Level 0 -> 9",
                                                                                     "Potency Level 9 -> 0")
    end
  end

  context "when the page is filtered to '0-2: Low' and sort is default" do
    let(:low_potency_option) { Potion.potency_level_options.find { |opt| opt[:name] == "0-2: Low" }[:id] }
    let(:low_potency_filter) do
      render_inline(described_class.new(selected_filter: low_potency_option, selected_sort: 0))
    end

    it "displays '0-2: Low' for potency level" do
      expect(low_potency_filter.css("select#filter_potency_level option[selected]").text).to eq("0-2: Low")
    end

    it "displays 'Default' for sort option" do
      expect(low_potency_filter.css("select#sort_potion_method option[selected='selected']").text).to eq("Default")
    end

    it "displays all expected filter options" do
      expect(low_potency_filter.css("select#filter_potency_level option").text).to include("All",
                                                                                           "0-2: Low",
                                                                                           "3-5: Medium",
                                                                                           "6-8: High",
                                                                                           "9-10: Legendary")
    end

    it "displays all expected sort options" do
      expect(low_potency_filter
      .css("select#sort_potion_method option").text).to include("Default",
                                                                "Name A -> Z",
                                                                "Name Z -> A",
                                                                "Potency Level 0 -> 9",
                                                                "Potency Level 9 -> 0")
    end
  end

  context "when the filter is default and sort is Name A -> Z" do
    let(:name_a_to_z_option) { Potion.sort_options.find { |opt| opt[:name] == "Name A -> Z" }[:id] }
    let(:name_a_to_z_filter) do
      render_inline(described_class.new(selected_filter: 0, selected_sort: name_a_to_z_option))
    end

    it "displays 'All'' for potency level" do
      expect(name_a_to_z_filter.css("select#filter_potency_level option[selected]").text).to eq("All")
    end

    it "displays 'Name A -> Z' for sort option" do
      expect(name_a_to_z_filter.css("select#sort_potion_method option[selected='selected']").text).to eq("Name A -> Z")
    end

    it "displays all expected filter options" do
      expect(name_a_to_z_filter.css("select#filter_potency_level option").text).to include("All",
                                                                                           "0-2: Low",
                                                                                           "3-5: Medium",
                                                                                           "6-8: High",
                                                                                           "9-10: Legendary")
    end

    it "displays all expected sort options" do
      expect(name_a_to_z_filter.css("select#sort_potion_method option").text).to include("Default",
                                                                                         "Name A -> Z",
                                                                                         "Name Z -> A",
                                                                                         "Potency Level 0 -> 9",
                                                                                         "Potency Level 9 -> 0")
    end
  end
end
