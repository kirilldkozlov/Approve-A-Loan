class CreateLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :logs do |t|
      t.string :name
      t.string :phone
      t.string :currency
      t.integer :loan_duration_months
      t.string :loan_purpose
      t.float :loan_amount
      t.integer :verdict

      t.timestamps
    end
  end
end
