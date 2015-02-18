class User < ActiveRecord::Base
  rolify
	# Include default devise modules. Others available are:
	# :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :timeoutable, :lockable,
		:rememberable, :trackable, :validatable, :recoverable

	has_one :profile
	has_one :email_setting
	before_validation :update_email
	before_create :build_default_profile, :build_default_email_setting, :create_system_account
	before_update :update_system_account

	validate :check_strong_password

	HOST="spc.edu.hk"

	def fullname
		return "#{self.profile.last_name} #{self.profile.first_name}"
	end

	# Static method

	def self.check_password(pwd)
		require "open3"
		chk=Open3.capture2("pwqcheck","-1","min=disabled,disabled,disabled,8,8",:stdin_data=>pwd)
	end


	def self.find_for_authentication(warden_conditions)
		where(:username=>warden_conditions[:username]).first
	end

	private

	def build_default_profile
		build_profile
	end

	def build_default_email_setting
		build_email_setting
	end

	def update_email
		self.email="#{username}@#{HOST}"
	end

	def update_system_account
		return true if self.password == nil 
		return true if Rails.env.development?
		begin
			Open3.capture2("sudo","aox","change","password", self.username,password) unless Rails.env.development?
		rescue
			self.errors.add(:system,"error. Please contact KCW.")
			return false
		end
	end

	def create_system_account
		username=self.username
		pwd=self.password
		require "open3"
		pwd=%x{pwgen -c -n -y -s 8 1}.chomp if pwd == ""
		username.downcase!
		email="#{username}@#{HOST}"
		Open3.capture2(["sudo","adduser", "--disabled-login --gecos -q",username].join" ") unless Rails.env.development?
		logger.debug "System account for #{username} is created."
		Open3.capture2("sudo","aox","add","user", username,pwd,email) unless Rails.env.development?
		logger.debug "Email account for #{username} is created with password #{pwd}"
	end

	def check_strong_password
		return nil if self.password == nil
		if self.password==""
			errors.add(:password,"cannot be empty")
			return false
		end	
		msg,state=User::check_password(self.password)
		errors.add(:password,msg) unless state.exitstatus==0
		return true
	end
end

