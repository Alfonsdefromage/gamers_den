class ListsController < ApplicationController

  def wishlist
    @list = List.where(user: current_user).find_by(name: "Wishlist")
    @bookmarks = Bookmark.where(list: @list)
  end

  def replace_button
    @list = List.where(user: current_user).find_by(name: "Wishlist")
    @game = Game.find(params[:game_id])
    @bookmark = Bookmark.find_by(game_id: params[:game_id], list: @list)
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("replace-#{params[:game_id]}", partial: "shared/wishlist_update", locals: { game: @game })
      end
    end
  end

end
