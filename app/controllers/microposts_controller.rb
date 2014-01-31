#require 'aws-sdk'

class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.post_save
      flash[:success] = "ツイートしました"
      redirect_to(:back)
    else
      errors = Array.new
      flash[:micropost_error] = @micropost
      redirect_to(:back)
    end
  end

  def file_upload
    @micropost = current_user.microposts.build
    @micropost.group_id = session[:group_id]
    session[:group_id] = nil

    file = params[:upload_file][:doc];
    error_msg = @micropost.doc_save_valid?(file)
    if error_msg.present?
      flash[:error] = error_msg
      redirect_to(:back)
    end

    if @micropost.doc_save(file)
      flash[:success] = "ドキュメントをアップロードしました。"
      redirect_to(:back)
    else
       flash[:micropost_error] = @micropost
      redirect_to(:back)
    end
  end

  def destroy
  # 画面からファイル削除機能
    @micropost.destroy
    redirect_to(:back)
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :group_id)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id]) # findだとデータがない場合、Exceptipnとなってしまう
      redirect_to root_url if @micropost.nil?
    end
end