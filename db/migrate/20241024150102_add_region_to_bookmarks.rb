class AddRegionToBookmarks < ActiveRecord::Migration[7.1]
  def change
    add_column :bookmarks, :region, :string, array: true, default: []
  end
end
