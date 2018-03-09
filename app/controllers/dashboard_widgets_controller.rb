class DashboardWidgetsController < ApplicationController
  before_action :set_widget, only: [:show, :edit, :update, :destroy]

  def dashboard
    @widgets = current_user.dashboard_widgets
  end

  def show
    if policy(@widget.policy_class.constantize).send(@widget.policy_method)
      data = DashboardWidgetDataGatherer.new(current_account, current_user, @widget).data
      if data
        render partial: "dashboard_widgets/widgets/#{@widget.partial}", locals: {data: data}
      else
        render partial: 'dashboard_widgets/unconfigured_widget'
      end
    else
      head :unauthorized
    end
  end

  def create
    last_used_row = current_user.dashboard_widgets.pluck("settings->'y'").max.to_i
    @widget = current_user.dashboard_widgets.new(create_dashboard_widget_params)
    @widget.settings = {x: 0, y: last_used_row + 1}
    @widget.save
    render status: :created
  end

  def edit
  end

  def update
    if params.dig(:dashboard_widget, :settings)
      updated_settings = params.require(:dashboard_widget).permit(settings: [:period])
      @widget.update_column(:settings, @widget.settings.merge(updated_settings[:settings]))
    end
    @widget.update(update_dashboard_widget_params)
  end

  def update_positions
    params[:updated_widgets].each_pair do |widget_id, position|
      widget = current_user.dashboard_widgets.find(widget_id)
      updated_settings = widget.settings.merge(position.each_pair { |key, value| position[key] = value.to_i })
      widget.update_column(:settings, updated_settings)
    end
    head :ok
  end

  def destroy
    @widget.destroy
  end

  private

  def set_widget
    @widget = current_user.dashboard_widgets.find(params[:id])
  end

  def create_dashboard_widget_params
    params.require(:dashboard_widget).permit(:type_id)
  end

  def update_dashboard_widget_params
    params.require(:dashboard_widget).permit(:call_center_id)
  end
end
