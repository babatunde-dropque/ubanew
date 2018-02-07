# This set of code will load custom parameters from setup-params.yml , Added by Muyide Ibukun

# this will also work
# SETUP_CONFIG = YAML.load_file("#{Rails.root.to_s}/config/setup-params.yml")[Rails.env]

SETUP_CONFIG = YAML.load_file("#{Rails.root}/config/setup-params.yml")[Rails.env]
