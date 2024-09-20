class Game < ApplicationRecord
  has_many :bookmarks

  validates :name, presence: true
  validates :name, uniqueness: { scope: :release_date }
  validates :platform, presence: true
  validates :release_date, presence: true
end
