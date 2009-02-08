env = ENV['RAILS_ENV'] || RAILS_ENV
AUTH_KEYS = YAML.load_file(RAILS_ROOT + '/config/auth.yml')[env]