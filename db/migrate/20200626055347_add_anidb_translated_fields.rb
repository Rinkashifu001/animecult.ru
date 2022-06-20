class AddAnidbTranslatedFields < ActiveRecord::Migration[5.2]
  def change
    add_column :anidb_credits, :title_translated, :string
    add_column :anidb_characters, :title_translated, :string
    add_column :anidb_creators, :title_translated, :string
    add_column :anidb_description_elements, :title_translated, :string
    add_column :anidb_songs, :title_translated, :string
    add_column :anidb_tags, :title_translated, :string
    add_column :anidb_tags, :description_translated, :string
  end
end