class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :restore, :destroy, :request_password_reset]
  after_action  :verify_authorized

  def index
    authorize User

    @q = current_account.users.ransack(params[:q])
    @users = @q.result
               .includes(:roles)
               .order_by_name
               .paginate(page: params[:page], per_page: per_page('users'))
  end

  def show
    authorize @user
    @tickets = @user.tickets.assigned.order(:response_due_at)
  end

  def new
    authorize User
    @user = User.new(time_zone: current_account.time_zone)
  end

  def create
    authorize User

    p = user_params || {}
    if p.present? && p[:password].blank?
      password = SecureRandom.hex(8)
      p[:password] = password
      p[:password_confirmation] = password
    end

    @user = current_account.users.create(p)

    if @user.new_record?
      render :new
    else
      EmailNotifierJob.perform_later(@user, EmailNotification.templates[:user_welcome])

      redirect_to users_path, notice: "#{@user.name} added!"
    end
  end

  def edit
    authorize @user
  end

  def update
    authorize @user

    if @user.update(user_params(@user))
      redirect_to user_path(@user), notice: "#{@user.name} updated!"
    else
      render :edit
    end
  end

  def bulk_update
    authorize User

    begin
      # Rails rejects blank array from parameters
      if params[:user].present?
        filtered_user_params = user_params.reject { |key, val| val.blank? }

        current_account.users.find(params[:user_ids]).each do |user|
          authorize user, :update?
          user.update_attributes!(filtered_user_params)
        end
      end
      flash[:notice] = 'Users have been updated.'
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = 'Update has failed. Please make sure you are entering valid values.'
    end

    redirect_back fallback_location: users_path
  end

  def destroy
    authorize @user
    if @user.destroy
      flash[:notice] = "#{@user.name} deleted!"
    else
      flash[:alert] = @user.errors[:base].join(' ')
    end
    redirect_back fallback_location: users_path
  end

  def request_password_reset
    authorize @user, :edit?

    EmailNotifierJob.perform_later(@user, EmailNotification.templates[:user_password_reset])

    redirect_to user_path(@user), notice: "Password reset e-mail has been sent to #{@user.name}"
  end

  private

  def set_user
    @user = current_account.users.find(params[:id])
  end

  def user_params(object_or_class = User)
    params.require(:user)
          .permit(policy(object_or_class)
          .permitted_attributes)
  end

  def check_user_limit
    redirect_to new_user_url if current_account.reached_user_limit?
  end
end
