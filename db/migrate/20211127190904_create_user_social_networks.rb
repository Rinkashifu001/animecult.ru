class CreateUserSocialNetworks < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!

  def change
    create_table :user_social_networks do |t|
      t.belongs_to :user, foreign_key: { to_table: :users }, index: false
      t.string :provider
      t.string :uid
      t.timestamps
    end
    add_index :user_social_networks, :user_id, algorithm: :concurrently
    add_index :user_social_networks, %i[provider uid], algorithm: :concurrently
  end
end
