class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :vote_posts
  has_many :posts, through: :vote_posts
  has_many :vote_comments
  has_many :comments, through: :vote_posts
  has_many :vote_replies
  has_many :replies, through: :vote_replies
end

