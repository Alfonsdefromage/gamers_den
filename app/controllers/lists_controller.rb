class ListsController < ApplicationController

  def index
    @lists = List.all.where(user: current_user)
    @bookmarks = Bookmark.all.where(user: current_user)
  end

  def show
    @list = List.find(params[:id])
    @bookmarks = Bookmark.all.where(user: current_user, platform: @list.name)
  end
end
