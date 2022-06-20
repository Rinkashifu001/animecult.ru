class CreateNews < ActiveRecord::Migration[5.2]
  def change
    create_table :news do |t|
      t.string :title
      t.string :descr_short
      t.string :descr_full
      t.string :link
      t.belongs_to :user
      t.boolean :is_applied, default: true
      t.boolean :is_cancelled, default: false
      t.timestamps
    end
  end
end
