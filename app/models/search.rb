class Search

  def search
    term = "/users/search.json?q=#{params[:search]}"
    @results = current_user.twitter.get(term)
  end
