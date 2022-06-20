class CreateAnidbDescriptionElements < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_description_elements do |t|
      t.string :title
      t.string :descr
      t.integer :anidb_description_id
      t.string :anidb_description_type
    end
  end
end
