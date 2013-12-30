class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id",
                                   class_name:  "Relationship",
                                   dependent:   :destroy
  has_many :followers, through: :reverse_relationships, source: :follower

  before_save { self.email = email.downcase }
  before_create :create_remember_token

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :name, presence: true, length: { maximum: 30}
	validates :email, presence: true,
		format: { with:VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
	has_secure_password # このメソッドは"authenticate"認証メソッドを提供する。
	validates :password, length: { minimum: 6 }

  # ランダム文字列生成
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def feed
    Micropost.from_users_followed_by(self)
  end

  # 暗号化（SH-1)
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def following?(other_user)
    self.relationships.find_by(followed_id: other_user.id)
  end

  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end

  def unfollow!(other_user)
    relationships.find_by(followed_id: other_user.id).destroy
  end

  private
    # ユーザートークンを生成
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
