class Post < ApplicationRecord
    has_many :comments
    has_many :vote_posts
    has_many :users, through: :vote_posts
    belongs_to :user
end
