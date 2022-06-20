class AddUserIdToSerialAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :serial_attachments, :user_id, :integer
    add_index :serial_attachments, :user_id
  end
end
