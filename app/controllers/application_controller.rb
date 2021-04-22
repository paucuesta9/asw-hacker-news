class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :authenticate, only: %i[ new, edit, update, create, destroy ]

    # Authenticate
    def authenticate
      unless @current_user
        repost('/auth/google_oauth2', params: {authenticity_token: form_authenticity_token})
      end
    end
end
