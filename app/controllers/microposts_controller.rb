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

    # file_name = params[:upload_file][:doc].original_filename;
    # @micropost.file_name = file_name
    # @micropost.file_path = "#{@micropost.id}/#{file_name}"
    # @micropost.doc_flg = true;
    # @micropost.content = "document Upoud data"
    # params[:upload_file][:doc].read # これがドキュメント
    # バリデートチェック
    # S3へのアップロード
    # ファイルパス設定

    #参考サイト
    # http://qiita.com/kkabetani/items/d2c72394a490293277cc

    # s3
    # http://akasata.com/articles/292
    if @micropost.doc_save(params[:upload_file][:doc])
      flash[:success] = "ドキュメントをアップロードしました。"
      redirect_to(:back)
    else
       flash[:micropost_error] = @micropost
      redirect_to(:back)
    end
  end

  def destroy
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