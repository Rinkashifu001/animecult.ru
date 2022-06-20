class CreateTranslators < ActiveRecord::Migration
  def change
    create_table :translators do |t|
      t.string :link
      t.string :title
    end
  end
end
