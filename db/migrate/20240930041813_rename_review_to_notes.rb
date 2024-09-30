class RenameReviewToNotes < ActiveRecord::Migration[7.1]
  def change
    rename_column :bookmarks, :review, :notes
  end
end
