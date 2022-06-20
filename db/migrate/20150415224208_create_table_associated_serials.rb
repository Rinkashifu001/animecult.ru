class CreateTableAssociatedSerials < ActiveRecord::Migration
  def change
    create_table :associated_serials, id: false do |t|
      t.integer :serial_id
      t.integer :associated_id
    end
  end
end
