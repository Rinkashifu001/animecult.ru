class CreateChapterLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :chapter_links do |t|
      t.string :title
      t.string :link
      t.boolean :is_applied, default: false
      t.boolean :is_cancelled, default: false
      t.belongs_to :account
      t.belongs_to :chapter
    end
  end
end
