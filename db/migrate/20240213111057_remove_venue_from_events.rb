class RemoveVenueFromEvents < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :venue, :string
  end
end
