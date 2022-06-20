class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.string :title
      t.string :descr_short
      t.string :descr_full
      t.belongs_to :serial
      t.timestamps
    end
  end
end
