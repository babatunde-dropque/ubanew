RailsAdmin.config do |config|

  config.main_app_name = ["Dropque", "BackOffice"]
  # or something more dynamic
  # config.main_app_name = Proc.new { |controller| [ "Dropque", "BackOffice - #{controller.params[:action].try(:titleize)}" ] }


  ### Popular gems integration

  ## == Devise ==
  # config.authenticate_with do
  #   warden.authenticate! scope: :user
  # end
  # config.current_user_method(&:current_user)

  config.authorize_with do
    if current_user.nil?
      redirect_to main_app.root_path
    else
        redirect_to main_app.root_path unless (current_user.email == "admin@dropque.com" || current_user.email == "ibukun@dropque.com" || current_user.email == "opeyemi@dropque.com" ||  current_user.email == "ibk@dropque.com" || current_user.email == "yinka@dropque.com" || current_user.email == "mustapha@dropque.com" )
    end
  end

  ## == Cancan ==
  # config.authorize_with :cancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
