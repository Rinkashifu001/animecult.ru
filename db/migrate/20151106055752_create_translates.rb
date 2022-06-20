class CreateTranslates < ActiveRecord::Migration
  def change
    create_table :translates do |t|
      t.belongs_to :serial
      t.text       :description
      t.boolean    :selected
    end
  end
end
