class AddDefaultToMotificationsShown < ActiveRecord::Migration[5.2]
  def change
    change_column_default :notifications, :shown, false
  end
end
