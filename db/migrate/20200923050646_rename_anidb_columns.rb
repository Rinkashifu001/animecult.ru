class RenameAnidbColumns < ActiveRecord::Migration[5.2]
  def change
    rename_column :creator_participates, :anidb_creator_id, :creator_id
    rename_column :creator_participates, :anidb_credit_id, :credit_id
    rename_column :character_participates, :anidb_character_id, :character_id
    rename_column :character_participates, :anidb_creator_id, :creator_id
    rename_column :song_participates, :anidb_song_id, :song_id
    rename_column :song_stuffs, :anidb_creator_id, :creator_id
    rename_column :song_stuffs, :anidb_credit_id, :credit_id
    rename_column :song_stuffs, :anidb_song_id, :song_id
  end
end
