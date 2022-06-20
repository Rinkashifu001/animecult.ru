class CreatePersonals < ActiveRecord::Migration[5.2]
  def change
    create_table :personals do |t|
      t.string :code
      t.integer :created_at
      t.integer :serial_id
      t.integer :chapter_id
    end
    add_index :personals, :code
  end
end
