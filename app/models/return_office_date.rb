class ReturnOfficeDate < ActiveRecord::Base
	has_many :return_office_members, dependent: :destroy
	validates :return_date, presence: true

	def defult_members_join_save
      User.find_each do |user|
        returnOfficeMembers = self.return_office_members.build
        returnOfficeMembers.user_id = user.id
        returnOfficeMembers.join_flg = "false"
        returnOfficeMembers.save
      end
	end

  def get_return_office_members
    self.return_office_members.find_by(id: self.id)
  end
end
