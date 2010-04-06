class HomeController < ApplicationController
  def index
    if logged_in?
      redirect_to :controller => "followees", :action => "index"
    end
  end
end
