class CreateAnidbSongParticipates < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_song_participates do |t|
      t.integer :serial_id
      t.integer :anidb_song_id
      t.integer :relation_id
    end
    add_index :anidb_song_participates, :serial_id
    add_index :anidb_song_participates, :anidb_song_id
  end
end
