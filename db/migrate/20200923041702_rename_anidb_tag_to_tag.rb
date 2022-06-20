class RenameAnidbTagToTag < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_tags, :tags
  end
end
