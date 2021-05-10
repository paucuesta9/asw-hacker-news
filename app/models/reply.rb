class Reply < ApplicationRecord
  validate :text_is_present
  belongs_to :user
  belongs_to :parent, :polymorphic => true
  has_many :vote_replies
  has_many :users, through: :vote_replies
  has_many :replies, as: :parent

  def getPost
      parent.getPost
  end
  
  private
    def text_is_present
      if text.present?
        errors.add(:text, "El texto no puede estar vacío") unless text.present?
      end
    end
end
