class CreateRevisions < ActiveRecord::Migration[5.2]
  def change
    create_table :revisions do |t|
      t.boolean :is_applied, default: false
      t.boolean :is_cancelled, default: false
      t.belongs_to :user
      t.json :body
      t.integer :correctable_id
      t.string :correctable_type
      t.timestamps
    end
    add_index :revisions, [:correctable_type, :correctable_id]
  end
end
