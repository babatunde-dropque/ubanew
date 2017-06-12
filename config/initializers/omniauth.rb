Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '77pjz5gg2tbjen', 'ulyR2uhyZvvncTrK'
  provider :facebook, '1018591381617959', 'cfebc2964c7cb6e9ba26c53b5f91b204'
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
end
