class RenameTypeToWidgetType < ActiveRecord::Migration[5.1]
  def change
    rename_column :dashboard_widgets, :type, :widget_type
  end
end
