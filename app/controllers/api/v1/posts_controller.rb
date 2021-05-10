class Api::V1::PostsController < ApplicationController
    def show
        @post = Post.select(:id, :title, :url, :text, :points, :user_id, :created_at).find(params[:postId])
        respond_to do |format|
        format.json { render json: @post}
        end
    end
end
