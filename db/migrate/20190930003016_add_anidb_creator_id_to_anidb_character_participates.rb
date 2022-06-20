class AddAnidbCreatorIdToAnidbCharacterParticipates < ActiveRecord::Migration[5.2]
  def change
    add_column :anidb_character_participates, :anidb_creator_id, :integer
    add_index :anidb_character_participates, :anidb_creator_id
  end
end
