class FolloweesController < ApplicationController
  #before_filter :login_required

  def index
    if logged_in?
      find_followees
    else
      redirect_to :controller => "sessions", :action => "new"
    end
  end

  def unfollow
    params.each do |key, value| 
      if value == "on"
        temp = "/friendships/destroy.xml?user_id=#{key}"
        #logger.debug "**#{temp}**\n"
        #begin
        @resp= current_user.twitter.post(temp)
        #rescue TwitterAuth::Dispatcher::Error => e
        #  logger.info "**#{e}**\n"
        #end
      end
    end
    find_followees
    redirect_to :action => "index"
  end

  def find_followees
    @tweets = current_user.twitter.get('/statuses/friends')
      @user = current_user
      @in = logged_in?
  end

  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg
    redirect_to :action => "index"
  end

end
