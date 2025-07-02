# -*- encoding : utf-8 -*-
module ActionMailer
  class Base
    #cattr_accessor :smtp_config

    #self.smtp_config = YAML::load(File.open("#{Rails.root}/config/smtp.yml"))[Rails.env]

    def self.smtp_settings
      @@smtp_settings = {
	      :address              => "mail.sinsemsmt.com.br",
	      :port                 => "25",
	      :domain               => "sinsemsmt.com.br",
	      :authentication       => 'plain',
	      :user_name            => "contato@sinsemsmt.com.br",
	      :password             => "mj@YayNcVHbK",
	      :enable_starttls_auto => true,
	      :openssl_verify_mode  => 'none'
	    }
    end

  end
end
