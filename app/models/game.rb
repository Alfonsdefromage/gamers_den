class Game < ApplicationRecord
  has_many :bookmarks

  validates :title, presence: true
  validates :title, uniqueness: { scope: :release_date }
  validates :platforms, presence: true
  validates :release_date, presence: true
end
