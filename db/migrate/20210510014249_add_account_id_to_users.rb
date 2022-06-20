class AddAccountIdToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :account_id, :integer
    add_index :users, :account_id
  end
end
