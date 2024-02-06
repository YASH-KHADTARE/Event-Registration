class ChangeUserNameToUsernameInUsers < ActiveRecord::Migration[7.1]
  def change
    rename_column :users, :name, :username
  end
end
