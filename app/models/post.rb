class Post < ApplicationRecord
  has_many :comments
  belongs_to :user
  belongs_to :category
  acts_as_votable
end

# has_many :comments, dependent: :destroy
