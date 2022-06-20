class CreateSerialTags < ActiveRecord::Migration
  def change
    create_table :serial_tags, id: false do |t|
        t.belongs_to :serial
        t.belongs_to :tag
    end
  end
end
