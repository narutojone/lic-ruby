class CreateTickets < ActiveRecord::Migration[5.1]
  def change
    create_table :tickets do |t|
      t.references :account
      t.references :assignee
      t.references :caller
      t.references :call_center

      t.integer :ticket_type
      t.integer :ticket_number
      t.integer :request_number
      t.integer :count
      t.integer :response_status
      t.integer :version_number

      t.string :first_name, limit: 50
      t.string :last_name, limit: 50
      t.string :url, limit: 255
      t.string :work_street, limit: 255
      t.string :work_city, limit: 100
      t.string :work_county, limit: 100
      t.string :work_state, limit: 50
      t.text :locate_instructions
      t.json :response_codes
      t.datetime :response_due_at
      t.datetime :closed_at

      t.timestamps
    end
  end
end
