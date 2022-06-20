class CreateElements < ActiveRecord::Migration
  def change
    create_table :elements do |t|
      t.integer :elem_type
      t.string :title
      t.text :description
    end
  end
end
