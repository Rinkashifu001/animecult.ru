class CreateImageElems < ActiveRecord::Migration[5.2]
  def change
    create_table :image_elems do |t|
      t.json :image
      t.belongs_to :review
    end
  end
end
