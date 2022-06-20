class AddAnidbIdToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :anidb_id, :integer
  end
end
