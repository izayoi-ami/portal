class EmailSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_email, only: [:auto_response, :auto_forward, :update]

  def auto_forward
  end

  def auto_response
  end

  def update
	password=params[:password]
	logger.debug (params[:email_setting])
	if current_user.valid_password?(password) and @email.update(email_params)
		render "responseUpdated"	
	else
		@email.errors.add(:password," is incorrect.") if !current_user.valid_password?(password)
		render "passwordError" 
	end
  end

  private

  def set_email
	@email = EmailSetting.find_by_user_id(current_user.id)
	@gmail = @email.gmail_address
  end

  def email_params
	params.require(:email_setting).permit(:message,:is_vacation,:is_forward)
  end


end
