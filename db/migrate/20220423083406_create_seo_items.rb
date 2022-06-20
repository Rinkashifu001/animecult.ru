class CreateSeoItems < ActiveRecord::Migration[5.2]
  def change
    create_table :seo_items do |t|
      t.string :domain
      t.string :controller_name
      t.string :action_name
      t.string :h1
      t.string :klass
      t.string :title
    end
  end
end
