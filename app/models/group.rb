class Group < ActiveRecord::Base
  has_many :relationship_group_users, dependent: :destroy
  has_many :document_manegers, dependent: :destroy
  has_many :microposts, dependent: :destroy
  default_scope -> { order('created_at DESC') }
  validates :name, presence: true, length: { maximum: 20 }
  validates :comment, presence: true, length: { maximum: 140 }
end
