class CreateAdblocks < ActiveRecord::Migration[5.2]
  def change
    create_table :adblocks do |t|
      t.string :title
    end
    add_index :adblocks, :title
  end
end
