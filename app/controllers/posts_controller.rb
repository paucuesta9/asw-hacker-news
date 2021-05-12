class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  # GET /posts or /posts.json
  def index
    @posts = Post.where(typePost: 'url').order('posts.points DESC') 
    @voted = VotePost.where(user_id: session[:user_id])
    #@posts= Post.all
  end

  # GET /newest or /newest.json
  def newest
    @posts = Post.where(:typePost => "url").or(Post.where(:typePost => "ask")).order('posts.created_at DESC')
    @voted = VotePost.where(user_id: session[:user_id])
  end
  
  #GET /submissions?id=id
  def submitted
    @id = params[:id]
    @posts = Post.where(user_id: @id).order('posts.created_at DESC')
    @voted = VotePost.where(user_id: @id)
  end
  
  # GET /upvoted
  def upvoted
     @posts = Post.where(:typePost => "url").or(Post.where(:typePost => "ask")).order('posts.created_at DESC')
     @voted = VotePost.where(user_id: session[:user_id])
  end
    
  # GET /posts/asks
  def asks
    @asks = Post.where(:typePost => "ask").order('posts.points DESC')
    @voted = VotePost.where(user_id: session[:user_id])
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = Comment.new
    @voted = VotePost.find_by(user_id: session[:user_id], post_id: @post.id)
    @votedcomments = VoteComment.where(user_id: session[:user_id])
    @votedreplies = VoteReply.where(user_id: session[:user_id])
  end
  
    # GET /posts/points or /posts/points.json
  def apiPoints
    @posts = Post.all
    format.json { render json: @users.order(:points) }
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts or /posts.json
  def create
    require 'uri'
    @post = Post.new(post_params)
    #guardar el user id que toqui
    @post.user_id = session[:user_id]
    bool = false
    booltita = false
    booltext = false
    boolurl = false
    if @post.title.empty?
      booltita = true;
    end
    if(!@post.text.empty?) 
      @post.typePost = "ask"
    end
    if(@post.text.empty?) 
      booltext = true
    end
    
    if(!@post.url.empty?) 
      if @post.url =~ URI::regexp
          @post.typePost = "url"
      else
        bool = true
      end
      if(@post.url.empty?) 
        boolurl = true;
      end
      if boolurl && booltext
        booltita = true
      end
    
      respond_to do |format|
        if booltita
          format.html { redirect_to '/submit', notice: "Some fields are not correct" }
          format.json { render :show, status: :created, location: @post }
        elsif bool == true
          format.html { redirect_to '/submit', notice: "URL not valid" }
          format.json { render :show, status: :created, location: @post }
        
        elsif @post.save
          if @post.typePost == "url" and not @post.text.empty?
            @comment = Comment.new(text: @post.text, user_id: current_user.id, post_id: @post.id, votes: 1)
            @comment.save
          end
          @vote = VotePost.new(:user_id => current_user.id, :post_id => @post.id)
          @vote.save
          @post.points = 1
          @post.save
          format.html { redirect_to '/newest', notice: "Post was successfully created." }
          format.json { render :show, status: :created, location: @post }
      
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :url, :text)
    end
  end
end