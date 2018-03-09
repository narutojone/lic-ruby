class CreateCallCenters < ActiveRecord::Migration[5.1]
  def change
    create_table :call_centers do |t|
      t.references :account
      t.string :name, limit: 50

      t.timestamps
    end
  end
end
