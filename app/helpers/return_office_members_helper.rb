module ReturnOfficeMembersHelper

	def get_user_name(user_id)
		User.find(user_id).name
	end

	def join_flg_display(join_flg)
		join_flg == "true" ? "出席" : "欠席"
	end

end
