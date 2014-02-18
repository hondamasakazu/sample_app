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

  private
    def update_params
      params.require(:return_office_member).permit(:user_id, :join_flg, :remarks,)
    end

end
