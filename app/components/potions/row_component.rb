module Potions
  class RowComponent < ViewComponent::Base
    def initialize(potion:)
      super()
      @potion = potion
    end

  private

    def can_edit?(user)
      helpers.current_user == user
    end
  end
end
