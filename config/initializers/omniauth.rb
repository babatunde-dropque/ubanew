Rails.application.config.middleware.use OmniAuth::Builder do
  provider :linkedin, '78m6am4vac8cy0', 'GCQYFVMWnfJji9do'
  provider :facebook, '1018591381617959', 'cfebc2964c7cb6e9ba26c53b5f91b204'
end
