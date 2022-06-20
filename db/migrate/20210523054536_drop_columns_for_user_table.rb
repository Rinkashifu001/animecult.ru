class DropColumnsForUserTable < ActiveRecord::Migration[5.2]
  def change
    remove_column :users, :is_editor, :boolean
    remove_column :users, :is_moderator, :boolean
  end
end
