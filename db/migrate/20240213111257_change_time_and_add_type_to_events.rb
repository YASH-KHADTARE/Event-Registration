class ChangeTimeAndAddTypeToEvents < ActiveRecord::Migration[7.1]
  def change
    change_column :events, :time, :time
    add_column :events, :type, :string
  end
end
