class VoteRepliesController < ApplicationController
    before_action :set_vote_reply, only: %i[ show edit update destroy ]

    # GET /vote_replies or /vote_replies.json
    def index
      @vote_reply = VoteReply.all
    end
  
    # GET /vote_replies/1 or /vote_replies/1.json
    def show
    end
  
    # GET /vote_replies/new
    def new
      @vote_reply = VoteReply.new
    end
  
    # GET /vote_replies/1/edit
    def edit
    end
  
    # POST /vote_replies or /vote_replies.json
    def create
      @vote_reply = VoteReply.new(user_params)
  
      respond_to do |format|
        if @vote_reply.save
          format.html { redirect_to @vote_reply, notice: "Reply vote was successfully created." }
          format.json { render :show, status: :created, location: @vote_reply }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @vote_reply.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /vote_replies/1 or /vote_replies/1.json
    def update
      respond_to do |format|
        if @vote_reply.update(user_params)
          format.html { redirect_to @vote_reply, notice: "Reply vote was successfully updated." }
          format.json { render :show, status: :ok, location: @vote_reply }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @vote_reply.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /vote_replies/1 or /vote_replies/1.json
    def destroy
      @vote_reply.destroy
      respond_to do |format|
        format.html { redirect_to vote_reply_url, notice: "Reply vote was successfully destroyed." }
        format.json { head :no_content }
      end
    end
    
    def upvote
    @replies = Replies.find(params[:id])
    VoteReplies.create(user_id: session[:user_id], replies_id: @replies.id)
    @replies.points += 1
    @replies.save
    redirect_to request.referrer
    end
  
   def unvote
    @replies = Replies.find(params[:id])
    VoteReplies.find_by(user_id: session[:user_id], replies_id: @replies.id).destroy
    @replies.points -= 1
    @replies.save
    redirect_to request.referrer
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
