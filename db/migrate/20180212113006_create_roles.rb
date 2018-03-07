class CreateRoles < ActiveRecord::Migration[5.1]
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.integer :permissions, array: true, null: false, default: []
      t.boolean :admin, null: false, default: false
    end
  end
end
