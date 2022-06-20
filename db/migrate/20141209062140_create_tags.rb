class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :parent_id
      t.integer :level
      t.string :title
      t.text :description
    end

    add_index :tags, :title
    add_index :tags, :parent_id
  end
end
