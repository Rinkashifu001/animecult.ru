class CreateSerials < ActiveRecord::Migration
  def change
    create_table :serials do |t|
      t.string :title
      t.string :english_title
      t.string :original_title
      t.string :aka
      t.integer :release
      t.text :description
    end
  end
end
