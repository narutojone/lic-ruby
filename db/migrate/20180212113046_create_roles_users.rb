class CreateRolesUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :roles_users do |t|
      t.belongs_to :role, null: false, index: true
      t.belongs_to :user, null: false, index: true
    end
    add_foreign_key :roles_users, :roles, name: 'roles_users_role_id_fkey'
    add_foreign_key :roles_users, :users, name: 'roles_users_user_id_fkey'
  end
end
