class AddAnidbDescriptionToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :anidb_description, :text
  end
end
