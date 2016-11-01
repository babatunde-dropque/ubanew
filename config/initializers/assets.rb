# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += %w( material.css )
Rails.application.config.assets.precompile += %w( material.js )
Rails.application.config.assets.precompile += %w( dashboard.css )
Rails.application.config.assets.precompile += %w( dashboard.js )


# because this is a specific page css and javascript, it need to be added here for compilation
Rails.application.config.assets.precompile += %w( applicants.css )
Rails.application.config.assets.precompile += %w( applicants.js )
Rails.application.config.assets.precompile += %w( notify.min.js )

Rails.application.config.assets.precompile += %w( dropzone.js )



# material design for boostrap for applicants view
Rails.application.config.assets.precompile += %w( material-boostrap.css )
Rails.application.config.assets.precompile += %w( material-boostrap.js )

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
