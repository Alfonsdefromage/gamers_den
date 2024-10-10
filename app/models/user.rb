class User < ApplicationRecord
  after_create :create_default_list
  has_many :lists, dependent: :destroy
  has_many :bookmarks
  has_many :games, through: :bookmarks
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true

  def create_default_list
    playstation_home
    playstation_hand
    nintendo_home
    nintendo_hand
    sega
    xbox
  end

  def playstation_home
    List.create(name: "Playstation", user: self)
    List.create(name: "Playstation 2", user: self)
    List.create(name: "Playstation 3", user: self)
    List.create(name: "Playstation 4", user: self)
    List.create(name: "Playstation 5", user: self)
  end

  def playstation_hand
    List.create(name: "Playstation Portable", user: self)
    List.create(name: "Playstation Vita", user: self)
  end

  def nintendo_home
    List.create(name: "NES|Famicon", user: self)
    List.create(name: "SNES|Super Famicon", user: self)
    List.create(name: "Nintendo 64", user: self)
    List.create(name: "Nintendo Gamecube", user: self)
    List.create(name: "Nintendo Wii", user: self)
    List.create(name: "Nintendo Wii U", user: self)
  end

  def nintendo_hand
    List.create(name: "Nintendo Switch", user: self)
    List.create(name: "Nintendo Game Boy", user: self)
    List.create(name: "Nintendo Game Boy Advance", user: self)
    List.create(name: "Nintendo DS", user: self)
    List.create(name: "Nintendo 3DS", user: self)
  end

  def sega
    List.create(name: "Sega Dreamcast", user: self)
  end

  def xbox
    List.create(name: "Xbox", user: self)
    List.create(name: "Xbox 360", user: self)
    List.create(name: "Xbox One", user: self)
    List.create(name: "Xbox Series X|S", user: self)
  end
end
