class AddFieldsToExternalDataTables < ActiveRecord::Migration[5.2]
  def change

    add_column :characters, :description, :string
    add_column :creators, :description, :string
    add_column :songs, :description, :string

    add_column :characters, :is_applied, :boolean, default: true
    add_column :creators, :is_applied, :boolean, default: true
    add_column :songs, :is_applied, :boolean, default: true

    add_column :characters, :is_cancelled, :boolean, default: false
    add_column :creators, :is_cancelled, :boolean, default: false
    add_column :songs, :is_cancelled, :boolean, default: false


    add_column :characters, :user_id, :integer
    add_column :creators, :user_id, :integer
    add_column :songs, :user_id, :integer
  end
end
