require "rails_helper"

RSpec.describe Navbar::NavbarComponent, type: :component do
  include ViewComponent::TestHelpers

  let(:navbar) { render_inline(described_class.new) }

  it "includes appropriate links" do
    hrefs = navbar.css("a").pluck("href")

    expect(hrefs).to include("/", "/potions", "/ingredients", "/logout")
  end

  it "loads the logo for the website" do
    img = navbar.at_css("img")

    expect(img).not_to be_nil
  end

  it "includes the website title" do
    expect(navbar.text).to include("POTION CRAFTER")
  end
end
