class User < ApplicationRecord
  has_many :posts
  has_many :comments
  has_many :vote_posts
  has_many :posts, through: :vote_posts
  has_many :vote_comments
  has_many :comments, through: :vote_posts
  has_many :vote_replies
  has_many :replies, through: :vote_replies
  
  def self.from_omniauth(response)
    User.find_or_create_by(uid: response[:uid], provider: response[:provider]) do |u|
      u.username = response[:info][:name]
      u.password = SecureRandom.hex(15)
    end
  end
end

