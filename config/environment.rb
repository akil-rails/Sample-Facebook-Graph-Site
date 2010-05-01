# Load the rails application
require File.expand_path('../application', __FILE__)

if File.exist?("#{Rails.root}/config/facebook_keys.yml")
  FACEBOOK_CONF = YAML::load(IO.read("#{Rails.root}/config/facebook_keys.yml"))['development']
else
  raise "Setup config/facebook_keys.yml"
end

# Initialize the rails application
Fbgraph::Application.initialize!
