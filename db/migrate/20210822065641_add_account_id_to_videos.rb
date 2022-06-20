class AddAccountIdToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :account_id, :integer
    add_index :videos, :account_id
  end
end
