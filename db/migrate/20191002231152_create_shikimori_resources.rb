class CreateShikimoriResources < ActiveRecord::Migration[5.2]
  def change
    create_table :shikimori_resources do |t|
      t.string :title
      t.string :value
      t.belongs_to :serial
    end
  end
end
