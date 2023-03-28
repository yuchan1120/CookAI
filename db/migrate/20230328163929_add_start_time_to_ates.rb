class AddStartTimeToAtes < ActiveRecord::Migration[6.1]
  def change
    add_column :ates, :start_time, :datetime, null: false
  end
end
