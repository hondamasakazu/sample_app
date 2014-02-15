class ReturnOfficeMember < ActiveRecord::Base
	belongs_to :return_office_date
	belongs_to :user
	validates :return_office_date, presence: true
	validates :user_id, presence: true
end
