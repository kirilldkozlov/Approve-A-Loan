class AddSaveStatusToLogs < ActiveRecord::Migration[5.1]
  def change
    add_column :logs, :status, :integer, default: 0
  end
end
