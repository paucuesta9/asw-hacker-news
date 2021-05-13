class Api::V1::RepliesController < ApplicationController
  skip_before_action :authenticate, :verify_authenticity_token

  def index
    if reply_params[:parent_id].blank?
      respond_to do |format|
        format.json { render json: {status: 400, error: 'Bad Request', message: "Parent id empty"}, status: 400 }
      end
    end
    if reply_params[:parent_type] == "Comment"
      @comment = Comment.find_by(id: reply_params[:parent_id])
      if (@comment.nil?)
        respond_to do |format|
          format.json { render json: {status: 400, error: 'Bad Request', message: "Comment id not exists"}, status: 400 }
        end
      else
        @reply_ids = Reply.select(:reply_id).where(parent_id: reply_params[:parent_id], parent_type: "Comment")
        if(@reply_ids.nil?)
          respond_to do |format|
            format.json { render json: {status: 404, error: 'Not found', message: "No Replies from a Comment with that ID"}, status: 404 }
          end
        end
        @replies = Reply.select(:id, :text, :created_at, :user_id, :parent_id, :votes).where(id: @reply_ids)
        respond_to do |format|
          format.json { render json: @replies, status: 200}
        end
      end
    elsif reply_params[:parent_type] == "Reply"
      @reply = Reply.find_by(id: reply_params[:parent_id])
      if (@reply.nil?)
        respond_to do |format|
          format.json { render json: {status: 400, error: 'Bad Request', message: "Reply id not exists"}, status: 400 }
        end
      else
        @reply_ids = Reply.select(:reply_id).where(parent_id: reply_params[:parent_id], parent_type: "Reply")
        if(@reply_ids.nil?)
          respond_to do |format|
            format.json { render json: {status: 404, error: 'Not found', message: "No Replies from a Reply with that ID"}, status: 404 }
          end
        end
        @replies = Reply.select(:id, :text, :created_at, :user_id, :parent_id, :votes).where(id: @reply_ids)
        respond_to do |format|
          format.json { render json: @replies, status: 200}
        end
      end
    end
  end 
  
    def upvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        if(@user.nil?)
          respond_to do |format|
            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
          end
        else
          @replies = Reply.find_by(id: params[:replyId])
          if(@replies.nil?)
            respond_to do |format|
              format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
            end
          else
            @vote = VoteReply.find_by(reply_id: params[:replyId], user_id: @user.id)
            if(!@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "Vote to the same Contribution already created"}, status: 409 }
              end
            else
              VoteReply.create(user_id: session[:user_id], reply_id: @replies.id)
              @replies.votes += 1
              @replies.save
              respond_to do |format|
                  format.json { render json: Reply.select(:id, :text, :votes, :user_id, :parent_id, :parent_type, :created_at).find(@replies.id), status: 201}
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
          @replies = Reply.find_by(id: params[:replyId])
          if(@replies.nil?)
            respond_to do |format|
              format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
            end
          else
            @vote = VoteReply.find_by(reply_id: params[:replyId], user_id: @user.id)
            if(@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "No Vote to the Contribution exists"}, status: 409 }
              end
            else
              VoteReply.find_by(user_id: session[:user_id], reply_id: @replies.id).destroy
              @replies.votes -= 1
              @replies.save
              respond_to do |format|
                  format.json { render json: Reply.select(:id, :text, :votes, :user_id, :parent_id, :parent_type, :created_at).find(@replies.id), status: 204}
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
        @reply = Reply.select(:id, :text, :created_at, :user_id, :parent_id, :votes).find_by(:id => params[:replyId])
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
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            if (@user.nil?)
              respond_to do |format|
                format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
              end
            else
              if reply_params[:parent_id].blank?
                respond_to do |format|
                  format.json { render json: {status: 400, error: 'Bad Request', message: "Parent id empty"}, status: 400 }
                end
              end
              if reply_params[:parent_type] == "Comment"
                @comment = Comment.find_by(id: reply_params[:parent_id])
                if (@comment.nil?)
                  respond_to do |format|
                    format.json { render json: {status: 400, error: 'Bad Request', message: "Comment id not exists"}, status: 400 }
                  end
                end
              elsif reply_params[:parent_type] == "Reply"
                @reply = Reply.find_by(id: reply_params[:parent_id])
                if (@reply.nil?)
                  respond_to do |format|
                    format.json { render json: {status: 400, error: 'Bad Request', message: "Reply id not exists"}, status: 400 }
                  end
                end
              else
                respond_to do |format|
                  format.json { render json: {status: 400, error: 'Bad Request', message: "Type is empty or not valid"}, status: 400}
                end
              end
              @reply = Reply.new(text: reply_params[:text], parent_id: reply_params[:parent_id], parent_type: reply_params[:parent_type], user_id: @user.id)
              if (@reply.text.empty?)
                  respond_to do |format|
                      format.json { render json: {status: 400, error: 'Bad Request', message: "Content is empty"}, status: 400}
                  end
              else
                  if @reply.save
                      @vote = VoteReply.new(:user_id => @user.id, :reply_id => @reply.id)
                      @vote.save
                      @reply.votes = 1
                      @reply.save
                      respond_to do |format|
                          format.json { render json: Reply.select(:id, :text, :votes, :user_id, :parent_id, :parent_type, :created_at).find(@reply.id), status: 201}
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
    
    def update
        if !request.headers["HTTP_X_API_KEY"].nil?
            @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
            @reply = Reply.find_by(:id => params[:replyId])
            if !@reply.nil?
                    if @user.id == @reply.user_id
                        @reply.update(reply_params)
                        respond_to do |format|
                            format.json { render json: Reply.select(:id, :text, :votes, :user_id, :parent_id, :parent_type, :created_at).find(@reply.id), status: 200}
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
          if (@user.nil?)
            respond_to do |format|
              format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
            end
          else
            @reply = Reply.find_by(:id => params[:reply_id])
            if !@reply.nil?
                if @user.id == @reply.user_id
                    @votes = VoteReply.where(reply_id: @reply.id)
                    @votes.each do |v|
                      v.destroy
                    end
                    @replies = Reply.where(parent_type: "Reply", parent_id: @reply.id)
                    @replies.each do |r|
                      r.destroy
                    end
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
          end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end
    end
    
    private
    def reply_params
      params.require(:reply).permit(:text, :parent_id, :parent_type)
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