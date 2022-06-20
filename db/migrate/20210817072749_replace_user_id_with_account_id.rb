class ReplaceUserIdWithAccountId < ActiveRecord::Migration[5.2]
  def change
    %w[serials elements chapters news reviews].each do |table|
      add_column table, :account_id, :integer
      add_index table, :account_id
    end
  end
end
