class AddDeletedAtToRegistrations < ActiveRecord::Migration[7.1]
  def change
    add_column :registrations, :deleted_at, :timestamp
  end
end
