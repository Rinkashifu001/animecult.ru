class FixTableDescriptionElementsTags < ActiveRecord::Migration[5.2]
  def change
    rename_column :description_elements_tags, :anidb_description_element_id, :description_element_id
    rename_column :description_elements_tags, :anidb_tag_id, :tag_id
  end
end
