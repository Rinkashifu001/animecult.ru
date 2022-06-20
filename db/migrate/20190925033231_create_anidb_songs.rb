class CreateAnidbSongs < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_songs do |t|
      t.string :title
    end
  end
end
