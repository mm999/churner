Braintree::Configuration.merchant_id = Figaro.env.braintree_merchant_id
Braintree::Configuration.public_key  = Figaro.env.braintree_public_key
Braintree::Configuration.private_key = Figaro.env.braintree_private_key

# Braintree doesn't read the environment correctly in heroku config variables, here is a small fix
if Figaro.env.braintree_environment == "sandbox"
	Braintree::Configuration.environment = :sandbox
elsif Figaro.env.braintree_environment == "production"
	Braintree::Configuration.environment = :production
end