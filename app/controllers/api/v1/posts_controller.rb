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

    def create
        if !request.headers["HTTP_X_API_KEY"].nil?
            @post = Post.new(post_params)
            
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            
            
            unless(@post.text.empty?) 
                @post.typePost = "ask"
            end
            
            unless(@post.url.empty?) 
                @post.typePost = "url"
            end

            if ((@post.url.empty? && @post.text.empty?) || @post.title.empty?)
                respond_to do |format|
                    format.json { render json: {status: 400, error: 'Bad Request', message: "Content is empty"}, status: 400}
                end
            else
                unless @post.typePost == "url" and Post.find_by(url: @post.url)
                    if @post.save
                        if @post.typePost == "url" and not @post.text.empty?
                            @comment = Comment.new(text: @post.text, user_id: current_user.id, post_id: @post.id, votes: 1)
                            @comment.save
                        end
                        @vote = VotePost.new(:user_id => current_user.id, :post_id => @post.id)
                        @vote.save
                        @post.points = 1
                        @post.save
                        respond_to do |format|
                            format.json { render json: @post, status: 200}
                        end
                    end
                else
                    respond_to do |format|
                        format.json { render json: {status: 409, error: 'Conflict', message: "Post with the same url already created"}, status: 409 }
                    end
                end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Uauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end    
    end

    def update
        if !request.headers["HTTP_X_API_KEY"].nil?
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            @post = Post.find_by(:id => params[:postId])
            if !@post.nil?
                if !@post.url.empty? && Post.exists?(:url => @post.url)
                    if @user.id == @post.user_id
                        @post.update(post_params)
                        respond_to do |format|
                            format.json { render json: @post, status: 200}
                        end
                    else
                        respond_to do |format|
                            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
                        end
                    end
                else
                    respond_to do |format|
                        format.json { render json: {status: 409, error: 'Conflict', message: "Post with the same url already created"}, status: 409 }
                    end
                end
            else
                respond_to do |format|
                    format.json { render json: {status: 404, error: 'Not found', message: "No Post with that ID"}, status: 404 }
                end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Uauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
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
