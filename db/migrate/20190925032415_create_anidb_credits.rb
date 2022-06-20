class CreateAnidbCredits < ActiveRecord::Migration[5.2]
  def change
    create_table :anidb_credits do |t|
      t.string :title
    end
  end
end
