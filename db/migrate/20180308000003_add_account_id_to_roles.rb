class AddAccountIdToRoles < ActiveRecord::Migration[5.1]
  def change
    add_column :roles, :account_id, :integer
  end
end
