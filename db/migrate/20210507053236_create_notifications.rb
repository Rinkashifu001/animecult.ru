class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.integer :correctable_id
      t.string :correctable_type
      t.boolean :shown
      t.belongs_to :user
      t.timestamps
    end
  end
end
