class RemoveUserNameFromApiUser < ActiveRecord::Migration[5.1]
  def change
    remove_column :api_users, :user_name
  end
end
