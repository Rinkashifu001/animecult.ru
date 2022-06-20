class CreateAnidbSongStuffs < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_song_stuffs do |t|
      t.integer :anidb_song_id
      t.integer :anidb_creator_id
      t.integer :anidb_credit_id
    end
    add_index :anidb_song_stuffs, :anidb_song_id
    add_index :anidb_song_stuffs, :anidb_creator_id
    add_index :anidb_song_stuffs, :anidb_credit_id
  end
end
