class Reply < ApplicationRecord
  belongs_to :user
  belongs_to :parent, :polymorphic => true
  has_many :vote_replies
  has_many :users, through: :vote_replies
  has_many :replies, :as => :parent
end
