class RepliesController < ApplicationController
  before_action :set_reply, only: %i[ show edit update destroy ]

  # GET /replies/1 or /replies/1.json
  def show
    @newReply = Reply.new
    @voted = VoteReply.find_by(user_id: session[:user_id], reply_id: @reply.id)
  end

  # GET /replies/new
  def new
    @reply = Reply.new
  end

  # GET /replies/1/edit
  def edit
  end

  # POST /replies or /replies.json
  def create
    @reply = Reply.new(reply_params)
    if not @reply.text.empty?
      @reply.user_id = current_user.id
      respond_to do |format|
        if @reply.save
          @vote = VoteReply.new(:user_id => current_user.id, :reply_id => @reply.id)
          @vote.save
          @reply.votes += 1
          @reply.save
          format.html { redirect_to @reply, notice: "Reply was successfully created." }
          format.json { render :show, status: :created, location: @reply }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @reply.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to request.referrer, notice: 'Text empty'
    end
  end

  # PATCH/PUT /replies/1 or /replies/1.json
  def update
    respond_to do |format|
      if @reply.update(reply_params)
        format.html { redirect_to @reply, notice: "Reply was successfully updated." }
        format.json { render :show, status: :ok, location: @reply }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reply.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /replies/1 or /replies/1.json
  def destroy
    while not Reply.find_by(parent: @reply).nil? do
      Reply.find_by(parent: @reply).destroy
    end
    @reply.destroy
    respond_to do |format|
      format.html { redirect_to replies_url, notice: "Reply was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_reply
      @reply = Reply.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def reply_params
      params.require(:reply).permit(:text, :parent_id, :parent_type)
    end
end
