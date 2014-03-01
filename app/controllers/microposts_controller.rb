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

    error_msg = @micropost.doc_save_valid?(params[:upload_file])
    if error_msg.present?
      flash[:error] = error_msg
    else
      if @micropost.doc_save(params[:upload_file][:doc])
        flash[:success] = "ドキュメントをアップロードしました。"
      else
        flash[:micropost_error] = @micropost
      end
    end

    redirect_to(:back)
  end

  def file_download
      @document = Micropost.find(params[:id])
      file_path = "#{Rails.root}#{@document.file_path}"
      stat = File::stat(file_path)
      file_name = File.basename(file_path)

      send_file(file_path, :filename => filename_for_content_disposition(file_name),
                                      :type => detect_content_type(file_path),
                                      :disposition => 'attachment')
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

    def filename_for_content_disposition(name)
      request.env['HTTP_USER_AGENT'] =~ %r{MSIE} ? ERB::Util.url_encode(name) : name
    end

    def detect_content_type(path)
      MIME::Types.type_for(path)[0].to_s
    end

end