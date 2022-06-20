class AddTransliteratedLinkToSerial < ActiveRecord::Migration
  def change
    add_column :serials, :transliterated_link, :string
  end
end
