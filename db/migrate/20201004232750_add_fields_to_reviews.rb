class AddFieldsToReviews < ActiveRecord::Migration[5.2]
  def change
    add_column :reviews, :user_id, :integer
    add_column :reviews, :is_applied, :boolean, default: true
    add_column :reviews, :is_cancelled, :boolean, default: false
  end
end
