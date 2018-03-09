class AddAccountIdToEmailNotifications < ActiveRecord::Migration[5.1]
  def change
    add_column :email_notifications, :account_id, :integer
  end
end
