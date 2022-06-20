class AddFieldsToSerials < ActiveRecord::Migration
  def change
    add_column :serials, :total_images, :integer
    add_column :serials, :total_frames, :integer
  end
end
