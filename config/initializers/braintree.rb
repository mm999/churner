Braintree::Configuration.merchant_id = Rails.application.secrets.braintree_merchant_id
Braintree::Configuration.public_key  = Rails.application.secrets.braintree_public_key
Braintree::Configuration.private_key = Rails.application.secrets.braintree_private_key

# Braintree doesn't read the environment correctly in heroku config variables, here is a small fix
if Rails.application.secrets.braintree_environment == "sandbox"
	Braintree::Configuration.environment = :sandbox
elsif Rails.application.secrets.braintree_environment == "production"
	Braintree::Configuration.environment = :production
end