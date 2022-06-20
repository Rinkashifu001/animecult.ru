class AddLinksToAnidb < ActiveRecord::Migration[5.2]
  def change
    add_column :anidb_characters, :link, :string
    add_column :anidb_creators, :link, :string
    add_column :anidb_songs, :link, :string
    add_index :anidb_characters, :link
    add_index :anidb_creators, :link
    add_index :anidb_songs, :link
  end
end
