class User < ApplicationRecord
  has_many :lists, dependent: :destroy
  has_many :bookmarks
  has_many :games, through: :bookmarks
  has_many :lists
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
end
