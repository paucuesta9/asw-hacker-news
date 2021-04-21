class VoteReply < ApplicationRecord
  belongs_to :reply
  belongs_to :user
end
