class RemovePreviewDateFromChapters < ActiveRecord::Migration[5.2]
  def change
    remove_column :chapters, :preview_date, :string
  end
end
