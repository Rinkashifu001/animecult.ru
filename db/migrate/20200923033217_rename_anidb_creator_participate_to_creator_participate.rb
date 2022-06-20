class RenameAnidbCreatorParticipateToCreatorParticipate < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_creator_participates, :creator_participates
  end
end
