# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'jquery' # @3.7.1
pin 'sparkle', to: 'sparkle.js'
pin 'goop', to: 'goop.js'
pin 'remove_ingredient', to: 'remove_ingredient.js'
