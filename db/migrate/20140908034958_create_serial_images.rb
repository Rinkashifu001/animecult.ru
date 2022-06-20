class CreateSerialImages < ActiveRecord::Migration
  def change
    create_table :serial_images do |t|
      t.belongs_to :serial
      t.boolean :frame
    end
  end
end
