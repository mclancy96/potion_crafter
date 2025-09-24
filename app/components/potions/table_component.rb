module Potions
  class TableComponent < ViewComponent::Base
    def initialize(potions:, current_user: nil)
      super()
      @potions = potions
      @current_user = current_user
    end
  end
end
