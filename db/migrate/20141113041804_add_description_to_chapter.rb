class AddDescriptionToChapter < ActiveRecord::Migration
  def change
    add_column :chapters, :description, :text
  end
end
