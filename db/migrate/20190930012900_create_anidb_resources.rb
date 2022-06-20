class CreateAnidbResources < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_resources do |t|
      t.string :title
      t.string :value
      t.belongs_to :serial
    end
  end
end
