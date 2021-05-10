class Api::V1::PostsController < ApplicationController
    skip_before_action :verify_authenticity_token
    def show
        @post = Post.select(:id, :title, :url, :text, :points, :user_id, :created_at).find_by(:id => params[:postId])
        if !@post.nil?
            respond_to do |format|
                format.json { render json: @post, status: 200}
            end
        else
            respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Post with that ID"}, status: 404 }
            end
        end
    end

    def destroy
        if !request.headers["HTTP_X_API_KEY"].nil?
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            @post = Post.find_by(:id => params[:postId])
            if !@post.nil?
                if @user.id == @post.user_id
                    @post.destroy
                    respond_to do |format|
                        format.json { head :no_content, status: 204 }
                    end
                else
                    respond_to do |format|
                        format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
                    end
                end
            else
                respond_to do |format|
                    format.json { render json: {status: 404, error: 'Not found', message: "No Post with that ID"}, status: 404 }
                end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end
    end
end
