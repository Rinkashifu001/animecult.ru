class RenameAnidbSongParticipateToSongParticipate < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_song_participates, :song_participates
  end
end
