class AddFieldsToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_column :favorites, :title, :string
    add_column :favorites, :chapter_id, :integer
  end
end
