class CreateAnidbDescriptionElementsTags < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_description_elements_tags, id:false do |t|
      t.integer :anidb_description_element_id
      t.integer :anidb_tag_id
    end
  end
end
