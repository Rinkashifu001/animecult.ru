class CreateSerialElements < ActiveRecord::Migration
  def change
    create_table :serial_elements, id: false do |t|
      t.belongs_to :serial
      t.belongs_to :element
    end
  end
end
