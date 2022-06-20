class CreateSerialAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :serial_attachments do |t|
      t.belongs_to :serial
      t.string :cover
      t.boolean :is_applied, default: false
      t.belongs_to :user
      t.integer :external_id
      t.string :external_type

    end
  end
end
