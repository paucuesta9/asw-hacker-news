class VoteCommentsController < ApplicationController
    before_action :set_vote_comment, only: %i[ show edit update destroy ]

    # GET /vote_comments or /vote_comments.json
    def index
      @vote_comments = VotePost.all
    end
  
    # GET /vote_comments/1 or /vote_comments/1.json
    def show
    end
  
    # GET /vote_comments/new
    def new
      @vote_comments = VotePost.new
    end
  
    # GET /vote_comments/1/edit
    def edit
    end
  
    # POST /vote_comments or /vote_comments.json
    def create
      @vote_comment = VotePost.new(user_params)
  
      respond_to do |format|
        if @vote_comment.save
          format.html { redirect_to @vote_comment, notice: "Comment vote was successfully created." }
          format.json { render :show, status: :created, location: @vote_comment }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @vote_comment.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /vote_comments/1 or /vote_comments/1.json
    def update
      respond_to do |format|
        if @vote_comment.update(user_params)
          format.html { redirect_to @vote_comment, notice: "Comment vote was successfully updated." }
          format.json { render :show, status: :ok, location: @vote_comment }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @vote_comment.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /vote_comments/1 or /vote_comments/1.json
    def destroy
      @vote_comment.destroy
      respond_to do |format|
        format.html { redirect_to vote_post_url, notice: "Comment vote was successfully destroyed." }
        format.json { head :no_content }
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
