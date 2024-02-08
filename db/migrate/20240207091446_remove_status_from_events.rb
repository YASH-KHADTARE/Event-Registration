class RemoveStatusFromEvents < ActiveRecord::Migration[7.1]
  def change
    remove_column :events, :status, :string
  end
end