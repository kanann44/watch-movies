class User < ApplicationRecord
  has_secure_password
  validates :name, {uniqueness: true}
  validates :email, {uniqueness: true, presence: true}
  has_many :posts, dependent: :destroy
  has_many :likes

  def posts
    return Post.where(user_id: self.id)
  end
end
