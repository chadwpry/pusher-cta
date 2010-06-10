begin
  PUSHER = YAML.load_file("#{RAILS_ROOT}/config/pusher.yml")
rescue
#  logger.debug "Must be running on Heroku if this file doesn't exist"
end

Pusher.app_id = ENV['PUSHER_APP_ID'] || PUSHER[:app_id]
Pusher.key    = ENV['PUSHER_KEY'] || PUSHER[:key]
Pusher.secret = ENV['PUSHER_SECRET'] || PUSHER[:secret]

