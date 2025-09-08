# frozen_string_literal: true

class WelcomeController < ApplicationController
  before_action :require_logged_in

  def index; end
end
