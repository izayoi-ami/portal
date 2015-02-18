class UsersController < ApplicationController
  before_action :authenticate_user!
  def change_password
	@user = current_user
  end

  def update
	@user = User.find(current_user.id)
	if @user.update_with_password(user_params)
		@user.profile.update(require_change_password:false)
		return render "password_changed"
	end
	render "change_password"
  end

  def settings
  end

  def new
	return redirect_to root_path unless can? :new, @user
	@user=User.new
  end

  def create
	return redirect_to root_path unless can? :new, @user
	@user=User.create(create_user_params)
	return render "create_user_error" if @user.errors.any?
	@user.profile.update(profile_params)
  end

  def batch_create
	return redirect_to root_path unless can? :new, @user
	require 'spreadsheet'
	file = params[:user]
	sheet = Roo::Spreadsheet.open(file.path, extension: File.extname(file.original_filename)[1..-1])
	@success_users=[]
	@failed_users=[]

	sheet.parse(:header_search=>[]).drop(1).each{ |t|
		user=User.create(t.slice("username","password"))	
		if user.errors.any?
			@failed_users<<user
		else
			user.profile.update(t.slice("last_name","first_name"))
			@success_users<<user
		end	
	}
  end


  private

  def user_params
	params.required(:user).permit(:password,:password_confirmation,:current_password)
  end

  def create_user_params
	params.required(:user).permit(:username,:password)
  end

  def profile_params
	params.require(:profile).permit!
  end

end
