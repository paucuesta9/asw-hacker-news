class Post < ApplicationRecord
    has_many :comments
    has_many :vote_posts, dependent: :destroy
    has_many :users, through: :vote_posts
    belongs_to :user
end
