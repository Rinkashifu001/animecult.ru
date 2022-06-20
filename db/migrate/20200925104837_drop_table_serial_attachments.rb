class DropTableSerialAttachments < ActiveRecord::Migration[5.2]
  def change
    drop_table :serial_attachments
  end
end
