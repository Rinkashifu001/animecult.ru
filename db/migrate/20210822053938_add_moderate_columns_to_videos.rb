class AddModerateColumnsToVideos < ActiveRecord::Migration[5.2]
  def change
    add_column :videos, :is_applied, :boolean, default: true
    add_column :videos, :is_cancelled, :boolean, default: false
  end
end
