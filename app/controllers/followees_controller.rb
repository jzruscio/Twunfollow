class FolloweesController < ApplicationController
  before_filter :login_required
  def index
    if logged_in?
      find_followees
    else
      redirect_to :controller => "sessions", :action => "new"
    end
  end
 
  def follow
    flash[:notice] = ""
    params.each do |key,value|
      if value == "on"
        temp = "/friendships/create.xml?user_id=#{key}"
        current_user.twitter.post(temp)
        looked_up_user = lookup_user(key)
        flash[:notice] << "You are now following #{looked_up_user}<br>"
      end
    end
    redirect_to :action => "index"
  end
 
  def unfollow
    flash[:notice] = ""
    params.each do |key, value| 
      if value == "on"
        temp = "/friendships/destroy.xml?user_id=#{key}"
        @resp= current_user.twitter.post(temp)
        looked_up_user = lookup_user(key)
        flash[:notice] << "You are now unfollowing #{looked_up_user}<br>"
      end
    end
    find_followees
    redirect_to :action => "index"
  end
 
  def find_followees
    @tweets = current_user.twitter.get('/statuses/friends?cursor=-1')['users']
    cursor = current_user.twitter.get('/statuses/friends?cursor=-1')['next_cursor']
    #logger.debug "first cursor = #{cursor} type =  #{@tweets.type} length = #{@tweets.length}\n"
    while cursor > 0
      @tweets.concat( current_user.twitter.get("/statuses/friends?cursor=#{cursor}")['users'])
      cursor = current_user.twitter.get("/statuses/friends?cursor=#{cursor}")['next_cursor']
      #logger.debug "inside cursor = #{cursor} type =  #{@tweets.type} length = #{@tweets.length}\n"
    end
    #logger.debug "last cursor = #{cursor} type =  #{@tweets.type} length = #{@tweets.length}\n"
    @user = current_user
    @paged = @tweets.paginate(:page => params[:page], :per_page => 200)
  end
 
  def logout
    logout = current_user.twitter.post('/account/end_session.json')
    current_user.forget_me
    logger.debug "Current User: #{current_user[:name]} Logout #{logout}\n"
    redirect_to :action => "destroy", :controller => "sessions"
    #redirect_to :action => "index", :controller => "home"
  end
 
  private
  def redirect_to_index(msg = nil)
    flash[:notice] = msg
    redirect_to :action => "index"
  end

  def lookup_user(opts)
    current_user.twitter.get("/users/lookup.json?user_id=#{opts}")['screen_name']
  end
end
