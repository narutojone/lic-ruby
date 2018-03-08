class EmailSettingsController < ApplicationController
  before_action :set_account, only: [:edit, :update]
  before_action :enable_settings_section
  after_action :verify_authorized

  def edit
    authorize Account, :edit?
  end

  def update
    authorize @account, :update?
    @account.assign_attributes(settings_params)

    if @account.valid? && @account.save
      redirect_to edit_email_settings_path, notice: 'E-mail header and footer have been updated.'
    else
      render :edit
    end
  end

  private

  def set_account
    @account = current_account
  end

  def settings_params
    params.require(:account).permit(:email_header, :email_footer)
  end
end
