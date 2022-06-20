class CreateAnidbCharacterParticipates < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_character_participates do |t|
      t.integer :category
      t.integer :serial_id
      t.integer :anidb_character_id
    end
    add_index :anidb_character_participates, :serial_id
    add_index :anidb_character_participates, :anidb_character_id
  end
end
