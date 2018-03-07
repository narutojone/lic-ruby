class EmailNotificationsController < ApplicationController
  before_action :set_notification, only: [:edit, :update, :quick_toggle]
  before_action :enable_settings_section
  after_action :verify_authorized

  def index
    authorize EmailNotification
  end

  def edit
    authorize @notification
  end

  def update
    authorize @notification

    if @notification.update(notification_params)
      redirect_to edit_email_notification_path(@notification), notice: 'Email notification updated!'
    else
      render :edit
    end
  end

  def quick_toggle
    authorize @notification

    @notification.update(notification_params)
  end

  private

  def set_notification
    @notification = current_account.email_notifications.find(params[:id])
  end

  def notification_params
    params.require(:email_notification).permit(
      :enabled,
      :notifiable_role_id,
      :notifiable_user_id,
      :subject,
      :text
    )
  end
end
