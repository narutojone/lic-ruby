class CreateCallCentersUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :call_centers_users do |t|
      t.references :call_center
      t.references :user

      t.timestamps
    end
  end
end
