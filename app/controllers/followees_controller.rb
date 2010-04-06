class FolloweesController < ApplicationController
  #before_filter :login_required

  def index
    if logged_in?
      @user = current_user
      @tweets = current_user.twitter.get('/statuses/friends')
      @in = logged_in?
    else
      redirect_to :controller => "sessions", :action => "new"
    end
  end

#  def logout
#    current_user = nil
#    session[:user_id] = nil
#    redirect_to_index("You have successfully logged out (controller)")
#  end 

  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg
    redirect_to :action => "index"
  end

end
