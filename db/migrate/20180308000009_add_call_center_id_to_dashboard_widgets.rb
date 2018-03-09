class AddCallCenterIdToDashboardWidgets < ActiveRecord::Migration[5.1]
  def change
    add_column :dashboard_widgets, :call_center_id, :integer
  end
end
