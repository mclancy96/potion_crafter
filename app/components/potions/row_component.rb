module Potions
  class RowComponent < ViewComponent::Base
    def initialize(potion:, current_user: nil)
      super()
      @potion = potion
      @current_user = current_user
    end

  private

    def can_edit?(user)
      @current_user == user
    end
  end
end
