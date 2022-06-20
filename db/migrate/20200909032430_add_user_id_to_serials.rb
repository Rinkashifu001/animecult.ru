class AddUserIdToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :user_id, :integer
    add_index :serials, :user_id
  end
end
