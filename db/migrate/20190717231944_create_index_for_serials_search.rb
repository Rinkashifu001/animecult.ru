class CreateIndexForSerialsSearch < ActiveRecord::Migration[5.2]
  def change
    add_index :serials, [:video_date,:release], order: {video_date: 'DESC NULLS LAST', release: 'DESC NULLS LAST'}
  end
end
