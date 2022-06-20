class AddDescription2ToSerials < ActiveRecord::Migration
  def change
    add_column :serials, :description2, :text
  end
end
