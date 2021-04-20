class Post < ApplicationRecord
    has_many :comments, :as => :imageable
    belongs_to :user
end
