class RemovePlatformFromGames < ActiveRecord::Migration[7.1]
  def change
    remove_column :games, :platform, :string
  end
end
