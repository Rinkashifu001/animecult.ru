class AddContentTypeToRevisions < ActiveRecord::Migration[5.2]
  def change
    add_column :revisions, :content_type, :integer,default: 1
  end
end
