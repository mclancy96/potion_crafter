module Potions
  class FormComponent < ViewComponent::Base
    def initialize(potion:)
      super()
      @potion = potion
    end
  end
end
