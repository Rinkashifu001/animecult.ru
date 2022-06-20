class CreateExternalAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :external_attachments do |t|
      t.string :cover
      t.boolean :is_applied, default: false
      t.integer :external_id
      t.string :external_type
      t.belongs_to :user
    end
  end
end
