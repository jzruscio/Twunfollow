class FolloweesController < ApplicationController
  before_filter :login_required
 
  def index
    #@tweets = current_user.twitter.get('/statuses/friends_timeline')
    @tweets = current_user.twitter.get('/statuses/friends')
  end
end
