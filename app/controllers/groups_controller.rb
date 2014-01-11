class GroupsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user,      only: :destroy

  def index
    @groups = Group.paginate(page: params[:page])
  end

  def show
    @group = Group.find(params[:id])
    @users = User.paginate(page: params[:page])
  end

  def new
    @group = Group.new
  end

  def edit
    @group = Group.find(params[:id])
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash.now[:success] = "Group created!"
      redirect_to @group
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def update
    @group= Group.find(params[:id])
    if @group.update_attributes(group_params)
      flash.now[:success] = "Group updated"
      redirect_to @group
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    flash.now[:success] = "Group destroyed."
    redirect_to groups_url
  end

  def add_user_show
    @group = Group.find(params[:id])
    @users = User.paginate(page: params[:page])
  end

  private

    def group_params
      params.require(:group).permit(:name, :comment)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in
      redirect_to(root_path) if signed_in?
    end

end
