class ReturnOfficeDate < ActiveRecord::Base
	has_many :return_office_members, dependent: :destroy
	validates :return_date, presence: true
end
