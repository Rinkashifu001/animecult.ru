class RenameAnidbDescriptionElementToDescriptionElement < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_description_elements, :description_elements
  end
end
