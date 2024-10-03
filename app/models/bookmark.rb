class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :game

  validates :game_id, uniqueness: { scope: :user_id, message: "can only bookmark a game once" }
  validates :user_id, uniqueness: { scope: :game_id, message: "can only bookmark a game once" }
end
