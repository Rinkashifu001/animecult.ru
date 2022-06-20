class RenameAnidbResourceToResource < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_resources, :resources
  end
end
