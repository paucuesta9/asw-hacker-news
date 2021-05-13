class Api::V1::RepliesController < ApplicationController
  skip_before_action :authenticate, :verify_authenticity_token
    def upvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        if(@user.nil?)
          respond_to do |format|
            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
          end
        else
          @replies = Reply.find_by(id: params[:id])
          if(@replies.nil?)
            respond_to do |format|
              format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
            end
          else
            @vote = VoteReply.find_by(reply_id: params[:id], user_id: @user.id)
            if(!@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "Vote to the same Contribution already created"}, status: 409 }
              end
            else
              VoteReply.create(user_id: session[:user_id], reply_id: @replies.id)
              @replies.votes += 1
              @replies.save
              respond_to do |format|
                  format.json { render json: @replies, status: 201}
              end
            end
          end
        end
      else
        respond_to do |format|
          format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
        end
      end
    end
    
    def unvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        if(@user.nil?)
          respond_to do |format|
            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
        end
        else
          @replies = Reply.find_by(id: params[:id])
          if(@replies.nil?)
            respond_to do |format|
              format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
            end
          else
            @vote = VoteReply.find_by(reply_id: params[:id], user_id: @user.id)
            if(@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "No Vote to the Contribution exists"}, status: 409 }
              end
            else
              VoteReply.find_by(user_id: session[:user_id], reply_id: @replies.id).destroy
              @replies.votes -= 1
              @replies.save
              respond_to do |format|
                  format.json { render json: @replies, status: 204}
              end
            end
          end
        end
      else
        respond_to do |format|
          format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
        end
      end
    end
    
    
    def show
        @reply = Reply.select(:id, :text, :created_at, :user_id, :parent_id, :points).find_by(:id => params[:replyId])
        if !@reply.nil?
            respond_to do |format|
                format.json { render json: @reply, status: 200}
            end
        else
            respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
            end
        end
    end
    
    def create
        if !request.headers["HTTP_X_API_KEY"].nil?
            @comment = Comment.new(comment_params)
            
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])

            if (@comment.text.empty?)
                respond_to do |format|
                    format.json { render json: {status: 400, error: 'Bad Request', message: "Content is empty"}, status: 400}
                end
            else
                if @comment.save
                    #@comment = Comment.new(text: @post.text, user_id: @user.id, post_id: @post.id, votes: 1)
                    #@comment.save
                    @vote = VoteComment.new(:user_id => @user.id, :post_id => @post.id)
                    @vote.save
                    @comment.votes = 1
                    @comment.save
                    respond_to do |format|
                        format.json { render json: @comment, status: 200}
                    end
                end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end    
    end
    
    def update
        if !request.headers["HTTP_X_API_KEY"].nil?
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            @reply = Reply.find_by(:id => params[:replyId])
            if !@reply.nil?
                    if @user.id == @reply.user_id
                        @reply.update(reply_params)
                        respond_to do |format|
                            format.json { render json: @reply, status: 200}
                        end
                    else
                        respond_to do |format|
                            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
                        end
                    end
            else
                respond_to do |format|
                    format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
                end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end
    end
    
    def destroy
        if !request.headers["HTTP_X_API_KEY"].nil?
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            @reply = Reply.find_by(:id => params[:commentId])
            if !@reply.nil?
                if @user.id == @reply.user_id
                    @reply.destroy
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
                    format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
                end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end
    end
    
    private
    def reply_params
      params.require(:reply).permit(:text, :user_id, :parent_id)
    end
      # Use callbacks to share common setup or constraints between actions.
    def set_vote_post
      @vote_replies = VoteReply.find(params[:id])
    end
  
      # Only allow a list of trusted parameters through.
     def vote_reply_params
      params.require(:reply).permit(:reply_id, :user_id)
     end
end