class Api::V1::RepliesController < ApplicationController
  skip_before_action :authenticate, :verify_authenticity_token
    def upvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        @replies = Reply.find(params[:id])
        VoteReply.create(user_id: session[:user_id], reply_id: @replies.id)
        @replies.votes += 1
        @replies.save
        redirect_to request.referrer
      end
    end

    def unvote
      if !request.headers["HTTP_X_API_KEY"].nil?
        @user = User.find_by(:uid =>  request.headers["HTTP_X_API_KEY"])
        @replies = Reply.find(params[:id])
        VoteReply.find_by(user_id: session[:user_id], reply_id: @replies.id).destroy
        @replies.votes -= 1
        @replies.save
        redirect_to request.referrer
      end
    end
    
  private
      # Use callbacks to share common setup or constraints between actions.
      def set_vote_post
        @vote_replies = VoteReply.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def vote_reply_params
        params.require(:reply).permit(:reply_id, :user_id)
      end
end
