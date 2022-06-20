class RemoveEpisodeIdFromChapters < ActiveRecord::Migration[5.2]
  def change
    remove_column :chapters, :episode_id, :string
  end
end
