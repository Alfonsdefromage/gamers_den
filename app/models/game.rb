class Game < ApplicationRecord
  has_many :bookmarks
  has_many :users, through: :bookmarks

  validates :title, presence: true
  validates :title, uniqueness: { scope: :release_date }
  validates :platforms, presence: true
  validates :release_date, presence: true

  def bookmark(user)
    Bookmark.find_by(user: user, game: self)
  end
end
