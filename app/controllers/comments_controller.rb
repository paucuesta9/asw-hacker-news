class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show edit update destroy ]

  #GET /threads
  def threads
    @comments = Comment.where(user_id: @current_user.id)
  end

  #GET /upvoted 
  def upvoted
    @comments = Comment.joins(:users).where(id: @current_user.id)
  end

  # GET /comments/1 or /comments/1.json
  def show
    @reply = Reply.new
  end

  # GET /comments/new
  def new
      @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments or /comments.json
  def create
    @comment = Comment.new(comment_params)
    @comment.user_id = @current_user.id
    if not @reply.text.empty?
      respond_to do |format|
        if @comment.save
          @vote = VoteComment.new(:user_id => @current_user.id, :comment_id => @comment.id)
          @vote.save
          @comment.points += 1
          @comment.save
          format.html { redirect_to :controller => "posts", :action => "show", :id => @comment.post_id, notice: "Comment was successfully created." }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to request.referrer, notice: 'Text empty'
    end
  end

  # PATCH/PUT /comments/1 or /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to @comment, notice: "Comment was successfully updated." }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1 or /comments/1.json
  def destroy
    while not Reply.find_by(parent: @comment).nil? do
      Reply.find_by(parent: @comment).destroy
    end
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to comments_url, notice: "Comment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:text, :post_id)
    end
end
