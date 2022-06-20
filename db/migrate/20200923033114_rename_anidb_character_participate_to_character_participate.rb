class RenameAnidbCharacterParticipateToCharacterParticipate < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_character_participates, :character_participates
  end
end
