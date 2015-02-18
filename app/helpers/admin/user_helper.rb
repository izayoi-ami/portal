module Admin::UserHelper
	def user_unlock(username)
		User.where(:username=>username).first.unlock_access!
	end
end
