class Api::V1::CommentsController < ApplicationController
  skip_before_action :authenticate, :verify_authenticity_token
    # GET /vote_comments or /vote_comments.json
    def upvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        if(@user.nil?)
          respond_to do |format|
            format.json { render json: {status: 403, error: 'Forbidden', message: "Your api key (X-API-KEY Header) is not valid"}, status: 403 }
          end
        else
          @comment = Comment.find_by(id: params[:id])
          if(@comment.nil?)
              respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Reply with that ID"}, status: 404 }
              end
          else
            @vote = VoteComment.find_by(reply_id: params[:id], user_id: @user.id)
            if(!@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "Vote to the same Contribution already created"}, status: 409 }
              end
            else
          VoteComment.create(user_id: @user.id, comment_id: @comment.id)
          @comment.votes +=1
          @comment.save
          respond_to do |format|
                    format.json { render json: @comments, status: 201}
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
          @comment = Comment.find_by(id: params[:id])
          if(@comment.nil?)
              respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Comment with that ID"}, status: 404 }
              end
          else
            @vote = VoteComment.find_by(reply_id: params[:id], user_id: @user.id)
            if(@vote.nil?)
              respond_to do |format|
                format.json { render json: {status: 409, error: 'Conflict', message: "No Vote to the Contribution exists"}, status: 409 }
              end
            else
          VoteComment.create(user_id: @user.id, comment_id: @comment.id).destroy
          @comment.votes -=1
          @comment.save
          respond_to do |format|
                    format.json { render json: @comments, status: 201}
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
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_vote_comment
        @vote_comments = VoteComment.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def vote_comment_params
        params.require(:vote_comment).permit(:comment_id, :user_id)
      end
end
