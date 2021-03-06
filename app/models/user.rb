class User < ActiveRecord::Base
  has_many :microposts, dependent: :destroy
  has_many :relationship_group_users, dependent: :destroy
  has_many :return_office_members, dependent: :destroy
	before_save { self.email = email.downcase }
  before_create :create_remember_token

	#VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  #フューチャードメインのみ許可
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@fexd.co.jp+\z/i
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
    Micropost.where("user_id = ?", id)
  end

  def feed_for_group(group)
    Micropost.where("group_id = ?", group.id)
  end

  # 暗号化（SH-1)
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def join_group(group)
    self.relationship_group_users.find_by(group_id: group.id)
  end

  def join_groups?(group)
    self.relationship_group_users.exists?(group_id: group.id)
  end

  def join_groups
    self.relationship_group_users.map{|rgu| Group.find_by(rgu.group_id)}
  end

  def join_groups!(group)
    self.relationship_group_users.create!(group_id: group.id)
  end

  def unjoin_groups!(group)
    relationship_group_users.find_by(group_id: group.id).destroy
  end

  def sex_name
    self.sex == "M" ? "男" : "女"
  end
  private
    # ユーザートークンを生成
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end

end
