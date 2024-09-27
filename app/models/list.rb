class List < ApplicationRecord
  belongs_to :user
  has_many :bookmarks, dependent: :destroy
  has_many :games, through: :bookmarks

  validates :name, presence: true
  validates :name, uniqueness: { scope: :user_id }
end
