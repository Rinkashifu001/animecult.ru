class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :nickname
      t.boolean :is_admin, default: false
      t.boolean :is_moderator, default: false
      t.boolean :is_editor, default: false
    end
  end
end
