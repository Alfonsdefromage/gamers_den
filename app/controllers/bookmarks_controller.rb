class BookmarksController < ApplicationController

  def new
    @game = Game.find(params[:game_id])
    if Bookmark.find_by(game: params[:game_id], user: current_user).nil?
      @bookmark = Bookmark.new
    else
      @bookmark = Bookmark.find_by(game: params[:game_id], user: current_user)
    end
  end

  def create
    @game = Game.find(params[:game_id])
    @bookmark = Bookmark.new(bookmark_params)
    @bookmark.user = current_user
    @bookmark.owned = true
    @bookmark.wishlist = false
    @bookmark.game = @game
    if @bookmark.save
      create_list
      redirect_to game_path(@game)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @game = Game.find(params[:game])
    @bookmark = Bookmark.find(params[:id])
    @bookmark.destroy

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.replace("bookmark-#{@game.id}", partial: "turbo/deleted") }
      format.html { redirect_to game_path(@game) }
    end
  end

  def update
    @bookmark = Bookmark.find(params[:id])
    @bookmark.wishlist = false
    @bookmark.update(bookmark_params)
    create_list
    redirect_to game_path(@bookmark.game)
  end

  def move_to_owned
    @game = Game.find(params[:game])
    @bookmark = Bookmark.find_by(game: @game, user: current_user)
    @bookmark.owned = !@bookmark.owned
    @bookmark.wishlist = !@bookmark.wishlist
    @bookmark.platform = params[:bookmark_params][:platform]
    if @bookmark.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.remove("game-#{@game.id}")}
        format.html { redirect_to wishlist_path }
      end
    else
      render :wishlist_path, status: :unprocessable_entity
    end
  end

  def wishlist_update
    @game = Game.find(params[:game])
    @bookmark = Bookmark.find_or_initialize_by(game: @game, user: current_user)

    @bookmark.wishlist = !@bookmark.wishlist
    @bookmark.owned = !@bookmark.owned
    if @bookmark.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("wishlist-#{@game.id}", partial: "turbo/wishlisted", locals: { game: @game })}
        format.html { redirect_to game_path(@game) }
      end
    else
      render :wishlist_index, status: :unprocessable_entity
    end
  end

  def wishlist_index
    @bookmarks = current_user.bookmarks.where(wishlist: true)
  end

  def replace_button
    @bookmark = params[:bookmark]
    @game = Game.find(params[:game_id])
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace("replace-#{params[:game_id]}", partial: "shared/wishlist_update", locals: { game: @game })
      end
    end
  end

  private

  def create_list
    if List.find_by(user: current_user, name: @bookmark.platform).nil?
      List.create(user: current_user, name: @bookmark.platform)
    end
  end

  def bookmark_params
    params.require(:bookmark).permit(:completed, :platform, :game_id)
  end
end
