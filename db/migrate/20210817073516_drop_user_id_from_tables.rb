class DropUserIdFromTables < ActiveRecord::Migration[5.2]
  def change
    %w[serials elements chapters news reviews].each do |table|
      execute "update #{table} set account_id=user_id;"
      remove_column table, :user_id
    end

  end
end
