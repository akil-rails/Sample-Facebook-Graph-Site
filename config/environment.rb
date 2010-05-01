# Load the rails application
require File.expand_path('../application', __FILE__)

FACEBOOK_CONF = YAML::load(IO.read("#{Rails.root}/config/facebook_keys.yml"))['development']

# Initialize the rails application
Fbgraph::Application.initialize!
