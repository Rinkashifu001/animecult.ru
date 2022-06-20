class RenameExternalAttachmentToAttachment < ActiveRecord::Migration[5.2]
  def change
    rename_table :external_attachments, :attachments
  end
end
