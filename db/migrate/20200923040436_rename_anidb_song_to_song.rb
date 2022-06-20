class RenameAnidbSongToSong < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_songs, :songs
  end
end
