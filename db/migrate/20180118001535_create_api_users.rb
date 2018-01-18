class CreateApiUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :api_users do |t|
      t.string :user_name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
