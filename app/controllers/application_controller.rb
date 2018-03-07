class ApplicationController < ActionController::Base
  include Pundit

  rescue_from Pundit::NotAuthorizedError do |exception|
    flash[:alert] = 'Action not allowed.'
    redirect_to(request.referrer || root_path)
  end

  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_time_zone

  private

  def per_page(type)
    cookies.permanent["#{type}_pp"] = params[:per_page] if params[:per_page].present?
    cookies["#{type}_pp"]
  end

  def set_time_zone
    Time.zone = current_user&.time_zone
  end

  def enable_settings_section
    @_settings_section = true
  end
end
