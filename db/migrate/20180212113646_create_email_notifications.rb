class CreateEmailNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :email_notifications do |t|
      t.integer :template, null: false, default: 0
      t.boolean :enabled, null: false, default: false
      t.references :notifiable_role, null: true
      t.references :notifiable_user, null: true
      t.string :subject, null: false
      t.text :text, null: false
    end
    add_foreign_key :email_notifications, :roles, column: :notifiable_role_id, name: 'email_notifications_notifiable_role_id_fkey'
    add_foreign_key :email_notifications, :users, column: :notifiable_user_id, name: 'email_notifications_notifiable_user_id_fkey'
  end
end
