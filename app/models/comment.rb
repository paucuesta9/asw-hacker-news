class Comment < ApplicationRecord
    belongs_to :imageable, :polymorphic => true, optional: true
    has_many :comments, :as => :imageable
end
