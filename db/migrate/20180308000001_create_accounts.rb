class CreateAccounts < ActiveRecord::Migration[5.1]
  def change
    create_table :accounts do |t|
      t.string :name, limit: 255
      t.string :domain, limit: 50
      t.string :time_zone, limit: 255

      t.timestamps
    end
  end
end
