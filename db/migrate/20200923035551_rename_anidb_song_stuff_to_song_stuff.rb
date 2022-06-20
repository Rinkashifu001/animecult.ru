class RenameAnidbSongStuffToSongStuff < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_song_stuffs, :song_stuffs
  end
end
