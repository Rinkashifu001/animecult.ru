class AddColumnEpisodeIdToChapters < ActiveRecord::Migration
  def change
    add_column :chapters, :episode_id, :string
  end
end
