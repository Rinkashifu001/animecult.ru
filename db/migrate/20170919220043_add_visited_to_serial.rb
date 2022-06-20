class AddVisitedToSerial < ActiveRecord::Migration
  def change
    add_column :serials,:visited_at,:integer
    add_index :serials, :visited_at
  end
end
