class AddPlatformToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :bookmarks, :platform, :string
  end
end
