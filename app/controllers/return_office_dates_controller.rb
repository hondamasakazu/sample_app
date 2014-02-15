class ReturnOfficeDatesController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user,      only: :destroy

  def index
    @return_office_dates = ReturnOfficeDate.paginate(page: params[:page])
  end

  def new
    @return_office_date = ReturnOfficeDate.new
    @return_office_date.start_time = "0"
    @return_office_date.start_min = "0"
    @return_office_date.end_time = "0"
    @return_office_date.end_min = "0"
    @select_time = Hash[(0..23).map{|x| ["#{x}時", x]}]
    @select_min = Hash[(0..59).select{|x| x % 10 == 0}.map{|x| ["#{x}分", x]}]
  end

  def edit
    @return_office_date = ReturnOfficeDate.find(params[:id])
    @select_time = Hash[(0..23).map{|x| ["#{x}時", x]}]
    @select_min = Hash[(0..59).select{|x| x % 10 == 0}.map{|x| ["#{x}分", x]}]
  end

  def create
    @return_office_date = ReturnOfficeDate.new(return_office_date_params)
    if @return_office_date.save
      unless @return_office_date.defult_members_join_save
        redirect_to return_office_dates_url
        return
      end
      flash[:success] = "帰社日情報を作成しました。"
      redirect_to return_office_dates_url
    else
      redirect_to new_return_office_date_url
    end
  end

  def update
    @return_office_date = ReturnOfficeDate.find(params[:id])
    if @return_office_date.update_attributes(return_office_date_params)
      flash[:success] = "帰社日情報を更新しました。"
      redirect_to return_office_dates_url
    else
      render 'edit'
    end
  end

  def destroy
    ReturnOfficeDate.find(params[:id]).destroy
    flash[:success] = "帰社日情報を削除しました。"
    redirect_to return_office_dates_url
  end

    def return_office_date_params
      params.require(:return_office_date).permit(
      							:return_date, :start_time, :end_time, :location)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in
      redirect_to(root_path) if signed_in?
    end

end
