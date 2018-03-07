class DashboardWidget < ApplicationRecord
  belongs_to :user, inverse_of: :dashboard_widgets, optional: false

  validates :type, presence: true, inclusion: {in: DASHBOARD_WIDGETS.keys}
  validates :settings, presence: true

  def partial
    DASHBOARD_WIDGETS[type][:partial]
  end

  def policy_class
    DASHBOARD_WIDGETS[type][:policy_class]
  end

  def policy_method
    DASHBOARD_WIDGETS[type][:policy_method]
  end

  def has_settings?
    DASHBOARD_WIDGETS[type][:multiple]
  end
end
