class TopController < ApplicationController
  skip_before_action :authenticate_user!

  def home; end
end
