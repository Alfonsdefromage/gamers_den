class SearchController < ApplicationController
  def index
    @results = search_for_games
  end

  def suggestions
    @results = search_for_games

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update('suggestions', partial: 'search/suggestions', locals: { results: @results })
      end
    end
  end

  private

  def search_for_games
    @bookmarks = Bookmark.all.where(user: current_user)
    if params[:query].blank?
      Game.all
    else
      @games = Game.where("title ILIKE ?", "%#{params[:query]}%")
    end
  end
end
