class User < ApplicationRecord
  validates :line_id, presence: true
  enum mode: %i(talk search)
end
