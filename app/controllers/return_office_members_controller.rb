class ReturnOfficeMembersController < ApplicationController

  def show
  	@return_office_date = ReturnOfficeDate.find(params[:id]);
  	@return_office_members = @return_office_date.return_office_members
    @return_office_join_cnt = @return_office_members.where("join_flg = ?", "true").count
    @return_office_unjoin_cnt = @return_office_members.where("join_flg = ?", "false").count
  end

  def update
    @return_office_member = ReturnOfficeMember.find(params[:id])
    @return_office_member.update_attributes(update_params)
    flash.now[:success] = "Profile updated"
    redirect_to return_office_member_url(@return_office_member.return_office_date_id)
  end

  private
    def update_params
      params.require(:return_office_member).permit(:user_id, :join_flg, :remarks,)
    end
end
