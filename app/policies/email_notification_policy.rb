class EmailNotificationPolicy < ApplicationPolicy
  def index?
    has_permission?('index')
  end

  def edit?
    update?
  end

  def quick_toggle?
    update?
  end

  def update?
    has_permission?('update')
  end

  private

  def has_permission?(activity)
    user.has_permission?('email_notification', activity)
  end
end
