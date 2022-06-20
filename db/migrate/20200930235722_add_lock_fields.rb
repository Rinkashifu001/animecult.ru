class AddLockFields < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :is_locked, :boolean, default: false
    add_column :serials, :elements_are_locked, :boolean, default: false
  end
end
