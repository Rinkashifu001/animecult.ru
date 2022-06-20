class AddUserReferanceToManyTables < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    %i[chapters chapter_links elements news notifications reviews serials videos].each do |table_name|
      add_reference table_name, :user, foreign_key: { to_table: :users }, index: false
      add_index table_name, :user_id, algorithm: :concurrently
    end
  end
end
