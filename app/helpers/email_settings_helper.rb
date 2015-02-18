module EmailSettingsHelper
	def setCorrectOwner
		require "open3"
		User.all.each{ |user|
			username=user.username
			file_path="/home/#{username}"
			Open3.capture2("sudo chown #{username}.#{username} #{[".forward",".vacation.msg"].map{ |x| "#{file_path}/#{x}"}.join " "}")
			Open3.capture2("sudo chmod 644 #{[".forward",".vacation.msg"].map{ |x| "#{file_path}/#{x}"}.join " "}")
		}
		return nil
	end
end
