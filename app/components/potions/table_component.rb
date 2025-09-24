module Potions
  class TableComponent < ViewComponent::Base
    def initialize(potions:)
      super()
      @potions = potions
    end
  end
end
