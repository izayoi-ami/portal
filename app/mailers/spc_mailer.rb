class SpcMailer < Devise::Mailer
  default from: "system@spc.edu.hk"
  helper :application
  include Devise::Controllers::UrlHelpers

  def reset_password_instructions(record, token, opts={})
	opts[:subject]="Reset password for #{record.fullname} (#{record.username})"
	opts[:to]="mailhelp@spc.edu.hk"
	super	
  end	
		

end
