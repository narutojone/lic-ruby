class AccountPolicy < ApplicationPolicy
  def index?
    has_permission?('index')
  end

  def new?
    create?
  end

  def create?
    has_permission?('create')
  end

  def edit?
    update?
  end

  def update?
    has_permission?('update')
  end

  def update_all?
    has_permission?('update')
  end

  def destroy?
    has_permission?('destroy')
  end

  private

  def has_permission?(activity)
    user.has_permission?('role', activity)
  end
end
