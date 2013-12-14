class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
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

  # 暗号化（SH-1)
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  private
    # ユーザートークンを生成
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
