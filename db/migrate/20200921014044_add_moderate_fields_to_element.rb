class AddModerateFieldsToElement < ActiveRecord::Migration[5.2]
  def change
    add_column :elements, :is_applied, :boolean, default: true
    add_column :elements, :is_cancelled, :boolean, default: false
    add_column :elements, :user_id, :integer
    add_index :elements, :user_id
  end
end
