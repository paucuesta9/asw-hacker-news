class Post < ApplicationRecord
    has_many :comments, :as => :imageable
end
