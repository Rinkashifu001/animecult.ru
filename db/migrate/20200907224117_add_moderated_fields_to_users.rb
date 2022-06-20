class AddModeratedFieldsToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :is_moderator, :boolean, default:false
    add_column :users, :is_editor, :boolean, default:false
  end
end
