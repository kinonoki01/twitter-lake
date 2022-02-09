class ToppagesController < ApplicationController
  def index
    if logged_in?
      redirect_to folders_url
    end
  end
end
