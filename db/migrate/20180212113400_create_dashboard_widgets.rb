class CreateDashboardWidgets < ActiveRecord::Migration[5.1]
  def change
    create_table :dashboard_widgets do |t|
      t.references :user, null: false, index: true
      t.integer :type, null: false
      t.jsonb :settings, null: false, default: {}
    end
    add_foreign_key :dashboard_widgets, :users, name: 'dashboard_widgets_user_id_fkey'
  end
end
