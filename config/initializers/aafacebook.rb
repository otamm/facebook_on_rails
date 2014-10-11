#the reason this file is called 'aafacebook' is because we would need the facebook initializer to be executed
# before devise, and rails reads files alphabetically.
FACEBOOK_CONFIG = YAML.load_file("#{::Rails.root}/config/facebook.yml")[::Rails.env] #this last part will state that this is gonna configure the environment of the app.
