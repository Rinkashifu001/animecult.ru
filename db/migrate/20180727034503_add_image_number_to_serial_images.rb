class AddImageNumberToSerialImages < ActiveRecord::Migration
  def change
    add_column :serial_images, :image_number, :integer
  end
end
