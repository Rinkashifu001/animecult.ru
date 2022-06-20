class AddModeratedFieldsToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :is_applied, :boolean, default: true
    add_column :serials, :is_cancelled, :boolean, default: false
  end
end
