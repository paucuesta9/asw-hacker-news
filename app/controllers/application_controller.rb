class ApplicationController < ActionController::Base
    before_action :authenticate, only: [ :new, :edit, :update, :create, :destroy, :threads, :upvoted, :submitted, :comments, :upvoted, :upvote, :unvote ]

    def current_user
      return unless session[:user_id]
      @current_user ||= User.find(session[:user_id])
    end

    # Authenticate
    def authenticate
      unless current_user
        repost('/auth/google_oauth2', params: {authenticity_token: form_authenticity_token})
      end
    end
end
