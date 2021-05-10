class Api::V1::PostsController < ApplicationController
    def show
        @post = Post.select(:id, :title, :url, :text, :points, :user_id, :created_at).find_by(:id => params[:postId])
        if !@post.nil?
            respond_to do |format|
                format.json { render json: @post, status: 200}
            end
        else
            respond_to do |format|
                format.json { render json: {status: 404, error: 'Not found', message: "No Post with that ID"}, status: 404 }
            end
        end
    end
end
