require 'uri'
require 'cgi'
require 'mime/types'

class DocumentsController < ApplicationController

  def show
  	@document_management = DocumentManagement.find(params[:id])
  	session[:document_management_id] = @document_management.id
  end

  def upload
    @document = Document.new
    @document.document_management_id = session[:document_management_id]
    session[:document_management_id] = nil
    error_msg = @document.doc_save_valid?(params[:upload_file])

    if error_msg.present?
      flash[:error] = error_msg
      redirect_to document_path(@document.document_management_id)
      return
    end

    unless @document.doc_save(params[:upload_file][:doc])
      flash[:micropost_error] = @document
      redirect_to document_path(@document.document_management_id)
      return
    end

    flash[:success] = "ドキュメントをアップロードしました。"
    redirect_to document_managements_url
  end

  def download
      @document = Document.find(params[:id])
      file_path = "#{Rails.root}#{@document.file_path}"
      stat = File::stat(file_path)
      file_name = File.basename(file_path)

      send_file(file_path, :filename => filename_for_content_disposition(file_name),
                                      :type => detect_content_type(file_path),
                                      :disposition => 'attachment')
  end

  private
    def update_params
      params.require(:return_office_member).permit(:user_id, :join_flg, :remarks,)
    end

  def filename_for_content_disposition(name)
    request.env['HTTP_USER_AGENT'] =~ %r{MSIE} ? ERB::Util.url_encode(name) : name
  end

  def detect_content_type(path)
    MIME::Types.type_for(path)[0].to_s
  end

end
