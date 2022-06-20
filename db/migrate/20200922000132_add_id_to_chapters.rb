class AddIdToChapters < ActiveRecord::Migration[5.2]
  def change
    #add_column :chapters, :id, :serial
    add_column :chapters, :is_applied, :boolean, default: true
    add_column :chapters, :is_cancelled, :boolean, default: false
  end
end
