class ChangeUserToAccountIntonotifications < ActiveRecord::Migration[5.2]
  def change
    remove_column :notifications, :user_id, :integer
    add_column :notifications, :account_id, :integer
    add_index :notifications, :account_id
  end
end
