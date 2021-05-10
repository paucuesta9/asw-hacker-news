class Comment < ApplicationRecord
    validate :text_is_present
    belongs_to :post
    belongs_to :user
    has_many :vote_comments
    has_many :users, through: :vote_comments
    has_many :replies, :as => :parent

    def getPost
        post
    end
    
    private
      def text_is_present
        if text.present?
          errors.add(:text, "El texto no puede estar vacío") unless text.present?
        end
      end
end
