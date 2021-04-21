class VotePostsController < ApplicationController
    before_action :set_vote_post, only: %i[ show edit update destroy ]

    # GET /vote_posts or /vote_posts.json
    def index
      @vote_post = VotePost.all
    end
  
    # GET /vote_posts/1 or /vote_posts/1.json
    def show
    end
  
    # GET /vote_posts/new
    def new
      @vote_post = VotePost.new
    end
  
    # GET /vote_posts/1/edit
    def edit
    end
  
    # POST /vote_posts or /vote_posts.json
    def create
      @vote_post = VotePost.new(user_params)
  
      respond_to do |format|
        if @vote_post.save
          format.html { redirect_to @vote_post, notice: "Post vote was successfully created." }
          format.json { render :show, status: :created, location: @vote_post }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @vote_post.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /vote_posts/1 or /vote_posts/1.json
    def update
      respond_to do |format|
        if @vote_post.update(user_params)
          format.html { redirect_to @vote_post, notice: "Post vote was successfully updated." }
          format.json { render :show, status: :ok, location: @vote_post }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @vote_post.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /vote_posts/1 or /vote_posts/1.json
    def destroy
      @vote_post.destroy
      respond_to do |format|
        format.html { redirect_to vote_post_url, notice: "Post vote was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_vote_post
        @vote_posts = VotePost.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def vote_post_params
        params.require(:vote_post).permit(:post_id, :user_id)
      end
end
