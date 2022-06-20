class AddVideoDateToSerials < ActiveRecord::Migration[5.2]
  def change
    add_column :serials, :video_date, :datetime
  end
end
