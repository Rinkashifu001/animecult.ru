class CreateChapters < ActiveRecord::Migration
  def change
    create_table :chapters do |t|
      t.belongs_to :serial
      t.integer :chapter_id
      t.string :title
    end
  end
end
