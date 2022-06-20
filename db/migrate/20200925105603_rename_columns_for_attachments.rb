class RenameColumnsForAttachments < ActiveRecord::Migration[5.2]
  def change
    rename_column :attachments, :external_id, :main_object_id
    rename_column :attachments, :external_type, :main_object_type
  end
end
