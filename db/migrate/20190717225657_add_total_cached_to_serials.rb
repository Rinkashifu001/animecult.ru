class AddTotalCachedToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :total_cached, :integer
  end
end
