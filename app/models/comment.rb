class Comment < ApplicationRecord
    belongs_to :post
    belongs_to :user
    has_many :vote_comments
    has_many :users, through: :vote_comments
    has_many :replies, :as => :parent

    def getPost
        post
    end
end
