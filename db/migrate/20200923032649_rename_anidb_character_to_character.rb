class RenameAnidbCharacterToCharacter < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_characters, :characters
  end
end
