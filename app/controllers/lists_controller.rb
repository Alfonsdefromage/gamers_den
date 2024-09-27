class ListsController < ApplicationController

  def wishlist
    @list = List.where(user: current_user).find_by(name: "Wishlist")
  end
end
