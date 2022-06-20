class CreateSerialsTranslators < ActiveRecord::Migration[5.2]
  def change
    create_table :serials_translators, id: false do |t|
      t.integer :serial_id
      t.integer :translator_id
    end
    add_index :serials_translators, :serial_id
    add_index :serials_translators, :translator_id
  end
end
