class CreateChapterCorrect < ActiveRecord::Migration[5.2]
  def change
    create_table :chapters do |t|
      t.belongs_to :serial
      t.belongs_to :user
      t.string :title
      t.string :description
      t.string :user_title1
      t.string :user_title2
      t.boolean :is_applied, default: true
      t.boolean :is_cancelled, default:false
      t.integer :chapter_id
    end
  end
end
