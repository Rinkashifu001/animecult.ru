class AddIndexesToSerialTags < ActiveRecord::Migration
  def change
    add_index :serial_tags, :serial_id
    add_index :serial_tags, :tag_id
  end
end
