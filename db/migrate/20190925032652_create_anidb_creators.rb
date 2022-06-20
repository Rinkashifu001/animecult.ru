class CreateAnidbCreators < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_creators do |t|
      t.string :title
    end
  end
end
