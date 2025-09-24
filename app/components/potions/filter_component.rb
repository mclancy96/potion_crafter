# frozen_string_literal: true

module Potions
  class FilterComponent < ViewComponent::Base
    attr_reader :selected_filter, :selected_sort

    def initialize(selected_filter: nil, selected_sort: nil)
      super()
      @selected_filter = if selected_filter.nil?
                           helpers.params[:filter_potency_level]&.to_i
                         else
                           selected_filter.to_i
                         end

      @selected_sort = if selected_sort.nil?
                         helpers.params[:sort_potion_method]&.to_i
                       else
                         selected_sort.to_i
                       end
    end
  end
end
