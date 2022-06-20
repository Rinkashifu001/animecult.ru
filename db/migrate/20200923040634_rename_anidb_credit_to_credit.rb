class RenameAnidbCreditToCredit < ActiveRecord::Migration[5.2]
  def change
    rename_table :anidb_credits, :credits
  end
end
