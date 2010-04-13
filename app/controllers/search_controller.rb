require 'open-uri'
class SearchController < ApplicationController

  def index
    if params[:search].length == 0 
      flash[:notice] = "Please enter a search term"
      redirect_to :controller => "followees", :action => "index" and return
    end
    if params[:tweets] == "on"
      search_tweets(params[:search])
    end
    if params[:names] == "on"
      search_names(params[:search])
    end
  end
  
  def search_tweets(opts)
    term = "/users/search.json?q=#{opts}"
    @tweet_results = JSON.parse(open("http://search.twitter.com/search.json?q=#{CGI.escape(opts)}&show_user=true&result_type=mixed").read)['results']
  end
  
  def search_names(opts)
    @name_results = current_user.twitter.get("/users/search.json?q=#{opts}")
logger.debug "**#{@name_results}**\n"
  end
  
end
