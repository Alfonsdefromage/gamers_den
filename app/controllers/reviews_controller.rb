class ReviewsController < ApplicationController
  def new
    # this is the nested resource
    @game = Game.find(params[:game_id])
    @user = current_user
    @review = Review.new
  end

  def create
    @game = Game.find(params[:game_id])
    @review = Review.new(review_params)
    @review.game = @game
    @review.user = current_user
    respond_to do |format|
      if @review.save
        format.html { redirect_to game_path(@game) }
        format.text { render partial: 'reviews/review', locals: { review: @review }, formats: [:html] }
      else
        # render 'restaurants/show', status: :unprocessable_entity
        render 'new', status: :unprocessable_entity
      end
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to game_path(@review.game)
  end

  private

  def review_params
    params.require(:review).permit(:content, :rating)
  end
end
