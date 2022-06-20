class AddActiveNotificationsCountToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :active_notifications_count, :integer, default: 0, null: false
  end
end
