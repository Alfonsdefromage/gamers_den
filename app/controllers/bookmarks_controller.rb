class BookmarksController < ApplicationController

  def new
    @source = params[:format]
    @list = List.new
    @lists = List.all.where(user: current_user)
    Bookmark.new
  end

  def create
    @game = Game.find(params[:game_id])
    if params[:format] == "wishlist"
      @bookmark = Bookmark.new(list: List.where(user: current_user).find_by(name: "Wishlist"), game: @game)
      @bookmark.owned = false
        if @bookmark.save
          redirect_to game_path(@game)
        else
          render :new, status: :unprocessable_entity
        end
    else
      @bookmark = Bookmark.new
      if List.where(user: current_user).find_by(name: params[:platform]) == nil
        @list = List.new
        @list.name = params[:platform]
        @list.user = current_user
        @list.bookmarks << @bookmark
        if @list.save
          redirect_to game_path(@game)
        else
          render :new, status: :unprocessable_entity
        end
      else
        @list = List.where(user: current_user).find_by(name: params[:platform])
        @list.bookmarks << @bookmark
        @bookmark.list = @list
        @bookmark.game = @game
        @bookmark.owned = true
          if @bookmark.save
            redirect_to game_path(@game)
          else
            render :new, status: :unprocessable_entity
          end
      end
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:game_id, :list_id, :owned, :plaftform)
  end
end
