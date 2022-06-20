class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.belongs_to :serial
      t.belongs_to :episode
      t.datetime :video_date
      t.text :video_url
      t.string :details
      t.string :stuff
      t.belongs_to :translator
      t.string :source
    end
  end
end
