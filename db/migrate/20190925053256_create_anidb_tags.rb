class CreateAnidbTags < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_tags do |t|
      t.string :title
      t.string :description
    end
  end
end
