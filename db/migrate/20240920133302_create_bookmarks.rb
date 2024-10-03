class CreateBookmarks < ActiveRecord::Migration[7.1]
  def change
    create_table :bookmarks do |t|
      t.boolean :completed
      t.boolean :wishlist, default: false
      t.boolean :owned, default: false
      t.string :platform
      t.text :notes
      t.references :user, null: false, foreign_key: true
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
