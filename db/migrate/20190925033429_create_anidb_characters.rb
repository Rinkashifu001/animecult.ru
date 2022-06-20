class CreateAnidbCharacters < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_characters do |t|
      t.string :title
    end
  end
end
