class RolesController < ApplicationController
  before_action :set_role, only: [:edit, :update, :destroy]
  before_action :enable_settings_section
  after_action  :verify_authorized

  def index
    authorize Role
    @roles = current_account.roles
  end

  def new
    @role = Role.new
    authorize @role
  end

  def create
    @role = current_account.roles.create role_params
    authorize @role
    if @role.new_record?
      render :new
    else
      redirect_to roles_path, notice: 'Role added!'
    end
  end

  def edit
    authorize @role
  end

  def update
    authorize @role
    if @role.update role_params
      redirect_to edit_role_path(@role), notice: 'Role updated!'
    else
      render :edit
    end
  end

  def edit_all
    authorize Role, :update_all?
    @roles = current_account.roles.where(admin: false)
  end

  def update_all
    authorize Role
    @roles = current_account.roles.where(admin: false)

    @roles.each do |role|
      permissions = params&.[](:permissions)&.[](role.id.to_s) || ActionController::Parameters.new(permissions: [])
      role.update(permission_params(permissions)) if permissions.present?
    end

    redirect_to edit_all_roles_path, notice: 'Permissions updated!'
  end

  def destroy
    authorize @role
    if @role.destroy
      flash[:notice] = 'Role deleted!'
    else
      flash[:alert] = @role.errors[:base].join(', ')
    end
    redirect_to roles_path
  end

  private

  def set_role
    @role = current_account.roles.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, permissions: [])
  end

  def permission_params(permission_params)
    permission_params.permit(permissions: [])
  end
end
