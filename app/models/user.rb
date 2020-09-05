class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books
  has_many :book_comments, dependent: :destroy

  has_many :favorites, dependent: :destroy

  has_many :follower, foreign_key: "follower_id", class_name: "Relationship", dependent: :destroy
  has_many :followed, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :following_user, through: :follower, source: :followed
  has_many :follower_user, through: :followed, source: :follower

  attachment :profile_image, destroy: false

  #バリデーションは該当するモデルに設定する。エラーにする条件を設定できる。
  validates :name, length: {maximum: 20, minimum: 2}, uniqueness: true
  validates :introduction, length: {maximum: 50}

  #ユーザーをフォローする
  def follow(user_id)
    follower.create(followed_id: user_id)
  end

  #ユーザーのフォローを解除する
  def unfollow(user_id)
    follower.find_by(followed_id: user_id).destroy
  end

  #すでにフォロー済みであればture返す
  def following?(user)
    following_user.include?(user)
  end
end
