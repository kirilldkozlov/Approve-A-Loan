class AddExpiryToApiUser < ActiveRecord::Migration[5.1]
  def change
    add_column :api_users, :expiry, :datetime
  end
end
