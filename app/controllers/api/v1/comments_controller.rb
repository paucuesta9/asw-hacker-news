class Api::V1::CommentsController < ApplicationController
  skip_before_action :authenticate, :verify_authenticity_token
    # GET /vote_comments or /vote_comments.json
  
    def upvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        @comment = Comment.find(params[:id])
        VoteComment.create(user_id: @user.id, comment_id: @comment.id)
        @comment.votes +=1
        @comment.save
        redirect_to request.referrer
      end
    end
  
    def unvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        @comment = Comment.find(params[:id])
        VoteComment.find_by(user_id: @user.id, comment_id: @comment.id).destroy
        @comment.votes -= 1
        @comment.save
        redirect_to request.referrer
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
