require 'open-uri'
class SearchController < ApplicationController

  def index
    if params[:search].length == 0 
      flash[:notice] = "Please enter a search term"
      redirect_to :controller => "followees", :action => "index" and return
    end
    if params[:tweets] == "on"
      search_tweets(no_period)
      #search_tweets(params[:search])
    end
    if params[:names] == "on"
      search_names(params[:search])
    end
    @user = current_user
  end
  
  def search_tweets(opts)
    term = "/users/search.json?q=#{opts}"
    #@tweet_results = JSON.parse(open("http://search.twitter.com/search.json?q=#{CGI.escape(opts)}&show_user=true&result_type=mixed").read)['results']
    @tweet_results = JSON.parse(open("http://search.twitter.com/search.json?q=#{opts}&show_user=true&result_type=mixed").read)['results']
    @tweet_results.each do |result|
      temp= current_user.twitter.get("/friendships/show.json?source_screen_name=#{current_user.login}&target_screen_name=#{result['from_user']}")
        #logger.debug "HI temp=#{temp['relationship']['target']['following']}\n"
        if temp['relationship']['source']['following']
          result['following'] = "true"
        end
    end
  end
  
  def search_names(opts)
    @name_results = current_user.twitter.get("/users/search.json?q=#{opts}")
  end
  
end
