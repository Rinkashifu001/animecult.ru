class CreateSerialStats < ActiveRecord::Migration[5.2]
  def change
    create_table :serial_stats do |t|
      t.integer :min_release
      t.integer :max_release

      t.timestamps
    end
  end
end
