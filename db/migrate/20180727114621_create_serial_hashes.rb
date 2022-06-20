class CreateSerialHashes < ActiveRecord::Migration
  def change
    create_table :serial_hashes do |t|
      t.integer :serial_id
      t.string :images_hash
    end
  end
end
