class CreateSpecialSerialTitles < ActiveRecord::Migration
  def change
    create_table :special_serial_titles do |t|
      t.integer :serial_id
      t.string :title
    end
    add_index :special_serial_titles, :serial_id
  end
end
