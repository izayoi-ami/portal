module Admin::RainloopHelper
	PLACEHOLDER="FULLNAME_PLACEHOLDER"
	PATH="/usr/share/rainloop/data/_data_faacdb1df2b8e874754e29344ae6e14d/_default_/storage/cfg"
	def initialize_rainloop_settings_for_user(user)
		file_path = "#{PATH}/#{user.username[0..1]}/#{user.email}/settings"
		require "open3"
		Open3.capture2("sudo sed -i 's/#{PLACEHOLDER}/#{user.fullname}/' #{file_path}")
	end

	def initialize_rainloop
		User.all.each {|x| initialize_rainloop_settings_for_user(x)}
	end
end
