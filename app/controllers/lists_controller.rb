class ListsController < ApplicationController

  def index
    @lists = List.all.where(user: current_user)
  end

end
