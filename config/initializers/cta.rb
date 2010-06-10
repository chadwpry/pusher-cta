begin
  CTA = YAML.load_file("#{RAILS_ROOT}/config/cta.yml")
rescue
  logger.debug "Must be running on Heroku if this file doesn't exist"
end

CTA_SERVER = ENV['CTA_SERVER'] || CTA[:server]
CTA_API_KEY = ENV['CTA_API_KEY'] || CTA[:api_key]
