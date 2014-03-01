class DocumentManagementsController < ApplicationController

  before_action :signed_in_user
  before_action :admin_user,      only: :destroy

  def index
    @document_managements = DocumentManagement.paginate(page: params[:page])
  end

  def new
    @document_management = DocumentManagement.new
  end

  def edit
    @document_management = DocumentManagement.find(params[:id])
  end

  def create
    @document_management = DocumentManagement.new(document_management_params)
    if @document_management.save
      flash[:success] = "DocumentManagement created!"
      redirect_to document_managements_url
    else
      render 'new'
    end
  end

  def update
    @document_management= DocumentManagement.find(params[:id])
    if @document_management.update_attributes(document_management_params)
      flash[:success] = "DocumentManagement updated"
      redirect_to document_managements_url
    else
      render 'edit'
    end
  end

  def destroy
    DocumentManagement.find(params[:id]).destroy
    flash.now[:success] = "DocumentManagement destroyed."
    redirect_to document_managements_url
  end

  private

    def document_management_params
      params.require(:document_management).permit(:name)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
