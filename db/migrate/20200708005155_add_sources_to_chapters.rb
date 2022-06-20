class AddSourcesToChapters < ActiveRecord::Migration[5.2]
  def change
    add_column :chapters, :user_title1, :string
    add_column :chapters, :user_title2, :string
  end
end
