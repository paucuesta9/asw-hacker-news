class Api::V1::UsersController < ApplicationController
  
  def show
    @user = User.find(params[:id])
    if !@user.nil?
      respond_to do |format|
        format.json { render json: @user, status: 200}
      end
    else
      respond_to do |format|
        format.json { render json: {status: 404, error: 'Not found', message: "No User with that UID"}, status: 404 }
      end
    end
  end

  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.json { render json: @user, status: 200}
      else
        format.json { render json: {status: 409, error: 'Conflict', message: "User with the same uid already created"}, status: 409 }
      end
    end
  end

  def update
    if !request.headers["HTTP_X_API_KEY"].nil?
      @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
      if !@user.nil?
        respond_to do |format|
          if @user.update(user_params)
            format.json { render json: @user, status: 200}
          else
            format.json { render json: @user.errors, status: :unprocessable_entity }
          end
        end
      else
        format.json { render json: {status: 404, error: 'Not found', message: "No User with that UID"}, status: 404 }
      end
    else
      format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
    end
  end

    private
    def user_params
      params.require(:user).permit(:username, :password, :about)
    end
end
