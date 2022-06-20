class RenameAnidbCreatorToCreator < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_creators, :creators
  end
end
