class UserPolicy < ApplicationPolicy
  def index?
    true || has_permission?('index')
  end

  def show?
    has_permission?('show')
  end

  def show_location?
    has_permission?('show_location')
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    (record.instance_of?(User) ? user.id == record.id : false) || has_permission?('update')
  end

  def destroy?
    user.id != record.id && has_permission?('destroy')
  end

  def bulk_update?
    has_permission?('update') # && !user.account.subscription.bulk_actions_limit
  end

  def permitted_attributes
    attrs = %i(email remember_me first_name last_name time_zone)

    if user && (has_permission?('create') || has_permission?('update'))
      attrs << {role_ids: []}
      attrs << :active if (record.instance_of?(User) ? user.id != record.id : true)
    end

    if user && record.instance_of?(User) && user.id == record.id
      attrs << :password << :password_confirmation
    end

    attrs
  end

  private

  def has_permission?(activity)
    user.has_permission?('user', activity)
  end
end
