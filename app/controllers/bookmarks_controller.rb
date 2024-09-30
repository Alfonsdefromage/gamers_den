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

  def move_to_owned
    @list = List.where(user: current_user).find_by(name: "Wishlist")
    @bookmark = Bookmark.find(params[:bookmark])
    @bookmark.owned = true
    @bookmark.platform = params[:bookmark_params][:platform]
    @game = Game.find(@bookmark.game_id)
    if @bookmark.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("game-#{@game.id}")}
        format.html { redirect_to wishlist_path }
      end
    else
      render :wishlist_path, status: :unprocessable_entity
    end
  end

  private

  def bookmark_params
    params.require(:bookmark).permit(:game_id, :list_id, :owned, :plaftform)
  end
end
