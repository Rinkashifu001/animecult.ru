class CreateAdminData < ActiveRecord::Migration[5.2]
  def up
    create_table :admin_data do |t|
      t.text :adv_desktop, default: ''
      t.text :adv_mobile, default: ''
    end
    AdminData.create
  end

  def down
    drop_table :admin_data
  end
end
