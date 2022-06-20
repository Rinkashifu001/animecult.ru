class AddAnidbDescriptionTranslatedToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :anidb_description_translated, :string
  end
end
