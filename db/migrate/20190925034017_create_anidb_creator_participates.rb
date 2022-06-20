class CreateAnidbCreatorParticipates < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_creator_participates do |t|
      t.integer :anidb_creator_id
      t.integer :serial_id
      t.integer :anidb_credit_id
    end
    add_index :anidb_creator_participates, :anidb_creator_id
    add_index :anidb_creator_participates, :serial_id
    add_index :anidb_creator_participates, :anidb_credit_id
  end
end
