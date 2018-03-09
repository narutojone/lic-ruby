class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :account
      t.references :plan

      t.integer :role_limit
      t.integer :user_limit

      t.timestamps
    end
  end
end
