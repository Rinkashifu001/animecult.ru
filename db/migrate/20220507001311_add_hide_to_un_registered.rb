class AddHideToUnRegistered < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :hide_to_unregistered, :boolean, default: false
    add_column :chapters, :hide_to_unregistered, :boolean, default: false
  end
end
