class Api::V1::CommentsController < ApplicationController
  skip_before_action :authenticate, :verify_authenticity_token
    
    def upvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        if(@user.nil?)
          respond_to do |format|
            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
          end
        else
          @comment = Comment.find_by(id: params[:commentId])
          if(@comment.nil?)
              respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
              end
          else
            @vote = VoteComment.find_by(comment_id: params[:commentId], user_id: @user.id)
            if(!@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "Vote to the same Contribution already created"}, status: 409 }
              end
            else
          VoteComment.create(user_id: @user.id, comment_id: @comment.id)
          @comment.votes +=1
          @comment.save
          respond_to do |format|
                    format.json { render json: Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).find(@comment.id), status: 201}
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
          @comment = Comment.find_by(id: params[:commentId])
          if(@comment.nil?)
              respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Comment with that ID"}, status: 404 }
              end
          else
            @vote = VoteComment.find_by(comment_id: params[:commentId], user_id: @user.id)
            if(@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "No Vote to the Contribution exists"}, status: 409 }
              end
            else
                VoteComment.find_by(user_id: @user.id, comment_id: @comment.id).destroy
                @comment.votes -=1
                @comment.save
                respond_to do |format|
                    format.json { render json: Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).find(@comment.id), status: 201}
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
        @comment = Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).find_by(:id => params[:commentId])
        if !@comment.nil?
            respond_to do |format|
                format.json { render json: @comment, status: 200}
            end
        else
            respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Comment with that ID"}, status: 404 }
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
              @post = Post.find_by(id: comment_params[:post_id])
              if (@post.nil?)
                respond_to do |format|
                  format.json { render json: {status: 400, error: 'Bad Request', message: "Post id not exists"}, status: 400 }
                end
              else
                @comment = Comment.new(text: comment_params[:text], post_id: comment_params[:post_id], user_id: @user.id)
                if (@comment.text.empty?)
                    respond_to do |format|
                        format.json { render json: {status: 400, error: 'Bad Request', message: "Content is empty"}, status: 400}
                    end
                else
                    if @comment.save
                        @vote = VoteComment.new(:user_id => @user.id, :comment_id => @comment.id)
                        @vote.save
                        @comment.votes = 1
                        @comment.save
                        respond_to do |format|
                            format.json { render json: Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).find(@comment.id), status: 201}
                        end
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
            @comment = Comment.find_by(:id => params[:commentId])
            if !@comment.nil?
                    if @user.id == @comment.user_id
                        @comment.update(comment_params)
                        respond_to do |format|
                            format.json { render json: Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).find(@comment.id), status: 200}
                        end
                    else
                        respond_to do |format|
                            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
                        end
                    end
            else
                respond_to do |format|
                    format.json { render json: {status: 404, error: 'Not found', message: "No Comment with that ID"}, status: 404 }
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
              @comment = Comment.find_by(:id => params[:commentId])
              if !@comment.nil?
                  if @user.id == @comment.user_id
                      @votes = VoteComment.where(comment_id: @comment.id)
                      @votes.each do |v|
                        v.destroy
                      end
                      @replies = Reply.where(parent_type: "Comment", parent_id: @comment.id)
                      @replies.each do |r|
                        r.destroy
                      end
                      @comment.destroy
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
                      format.json { render json: {status: 404, error: 'Not found', message: "No Comment with that ID"}, status: 404 }
                  end
              end
            end
        else
            respond_to do |format|
                format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
            end
        end
    end

    def upvoted
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        if(@user.nil?)
          respond_to do |format|
            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
          end
        else
            @comments_ids = VoteComment.select(:comment_id).where(user_id: @user.id)
            @comments = Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).where(id: @comments_ids)
            @replies_ids = VoteReply.select(:reply_id).where(user_id: @user.id)
            @replies = Reply.select(:id, :text, :votes, :user_id, :parent_id, :parent_type, :created_at).where(id: @replies_ids)
            @return = @comments + @replies
            respond_to do |format|
                format.json { render json: @return.sort_by! {|r| r.created_at}.reverse!, status: 200}
            end
        end
      else
        respond_to do |format|
          format.json { render json: {status: 401, error: 'Unauthorized', message: "You provided no api key (X-API-KEY Header)"}, status: 401 }
        end
      end
    end
    
    
    def allfromPost
      if comment_params[:post_id].blank?
        respond_to do |format|
          format.json { render json: {status: 400, error: 'Bad Request', message: "Post id empty"}, status: 400 }
        end
      end
      @comment_ids = Comment.select(:comment_id).where(post_id: comment_params[:post_id])
      if(@comments_ids.nil?)
        respond_to do |format|
          format.json { render json: {status: 404, error: 'Not found', message: "No Comments from a post with that ID"}, status: 404 }
        end
      end
      @comments = Comment.select(:id, :text, :votes, :user_id, :post_id, :created_at).where(id: @reply_ids)
      respond_to do |format|
        format.json { render json: @comments, status: 200}
      end
    end

    private
    def comment_params
      params.require(:comment).permit(:text, :post_id)
    end
      # Use callbacks to share common setup or constraints between actions.
      def set_vote_comment
        @vote_comments = VoteComment.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def vote_comment_params
        params.require(:vote_comment).permit(:comment_id, :user_id)
      end

      
end
