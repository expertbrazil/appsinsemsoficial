# -*- encoding : utf-8 -*-
APP_CONFIG = YAML::load(File.open("#{Rails.root.to_s}/config/configuration.yml"))[Rails.env]