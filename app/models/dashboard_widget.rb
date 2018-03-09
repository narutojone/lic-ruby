class DashboardWidget < ApplicationRecord
  belongs_to :user, inverse_of: :dashboard_widgets, optional: false
  belongs_to :call_center, optional: true

  validates :widget_type, presence: true, inclusion: {in: DASHBOARD_WIDGETS.keys}
  validates :settings, presence: true
  validate :enforce_the_same_account

  alias_attribute :type, :widget_type

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

  private

  def enforce_the_same_account
    if self.call_center && self.user && self.call_center.account_id != self.user.account_id
      self.errors.add(:call_center_id, "not from the same account with user")
    end
  end
end
