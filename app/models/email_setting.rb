class EmailSetting < ActiveRecord::Base
  belongs_to :user
  before_save :touchFiles, :prepareDotForwardFile

  HOME_DIR="/home"
  GMAIL_PATH="stpauls.edu.hk"

  def gmail_address
	"#{username}@#{GMAIL_PATH}"
  end

  private

  def touchFiles
	require "open3"
	file_path="#{HOME_DIR}/#{username}"
	Open3.capture2("sudo touch #{[".forward",".vacation.msg"].map{ |x| "#{file_path}/#{x}"}.join " "}")
	Open3.capture2("sudo chown #{username}.#{username} #{[".forward",".vacation.msg"].map{ |x| "#{file_path}/#{x}"}.join " "}")
	Open3.capture2("sudo chmod 644 #{[".forward",".vacation.msg"].map{ |x| "#{file_path}/#{x}"}.join " "}")
  end

  def prepareDotForwardFile
	begin
		return true if Rails.env.development?
		updateDotForwardFile
		updateMessageFile
	rescue
		self.errors.add(:system, "error. Please contact KCW for help.")
		return false
	end
  end
 
  def email
	self
  end

  def username
	self.user.username
  end

  def updateDotForwardFile 
	require "open3"
	file_path="#{HOME_DIR}/#{username}/.forward"	  
	Open3.capture2("sudo chmod 666 #{file_path}")
	File.open(file_path,"w") do |f|
		f.puts forward(email.is_forward)
		f.puts vacation(email.is_vacation)
	end
	Open3.capture2("sudo chmod 644 #{file_path}")
  end

  def updateMessageFile 
	require "open3"
	file_path="#{HOME_DIR}/#{username}/.vacation.msg"
	Open3.capture2("sudo chmod 666 #{file_path}")
	File.open(file_path,"w") do |f|
		f.puts vacation_header
		f.puts email.message
	end
	Open3.capture2("sudo chmod 644 #{file_path}")
  end

  def forward(enabled=false)
	return "\\#{username}, #{gmail_address}" if enabled
	return "\\#{username}"
  end

  def vacation(enabled=false)
	return "\\#{username}, \"|/usr/bin/vacation #{username}\"" if enabled
	return "\\#{username}"
  end

  def vacation_header
	<<-END
From: #{self.user.email} (#{self.user.fullname})
Subject: Re $SUBJECT (Auto Response)
X-Delivered-By-The-Graces-Of: The vacation program 
Precedence: bulk
	END
  end
end
