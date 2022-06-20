class ChangeDescriptionElementsFields < ActiveRecord::Migration[5.2]
  def change
    rename_column :description_elements, :anidb_description_id, :description_id
    rename_column :description_elements, :anidb_description_type, :description_type
  end
end
