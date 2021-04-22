class SessionsController < ApplicationController
  def omniauth
    user = User.from_omniauth(request.env['omniauth.auth'])
    if user.valid?
      session[:user_id] = user.id
      session[:username] = user.username
      current_user
      redirect_to '/'
    else
      redirect_to '/login'
    end
  end
  
  def destroy
    reset_session
    redirect_to '/'
  end
end