class AddAnidbAkaToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :anidb_aka, :string
  end
end
