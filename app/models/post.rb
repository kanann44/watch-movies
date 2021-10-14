class Post < ApplicationRecord
validates :comment, {presence: true, length: {maximum: 200}}
validates :title, {presence: true}
validates :movie_image, {presence: true}
validates :user_id, {presence: true}
validates :score, {presence: true}
belongs_to :user
  has_many :likes, -> { order(created_at: :desc) }, dependent: :destroy

  def user
    return User.find_by(id: self.user_id)
  end
end
