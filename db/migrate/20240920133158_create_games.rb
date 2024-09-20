class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :title
      t.string :platform
      t.string :genre
      t.string :publisher
      t.string :developer
      t.date :release_date
      t.string :cover_url
      t.text :summary

      t.timestamps
    end
  end
end
