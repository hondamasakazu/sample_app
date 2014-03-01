class GroupsController < ApplicationController
  before_action :signed_in_user
  before_action :admin_user,      only: :destroy

  def index
    @groups = Group.paginate(page: params[:page])
  end

  def show
    @group = Group.find(params[:id])
    @users = User.paginate(page: params[:page])
    @feed_items = current_user.feed_for_group(@group).paginate(page: params[:page])
    @micropost  = @group.microposts.build
    session[:group_id] = @group.id
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
      flash[:success] = "Group created!"
      redirect_to @group
    else
      render 'new'
    end
  end

  def update
    @group= Group.find(params[:id])
    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"
      redirect_to @group
    else
      render 'edit'
    end
  end

  def destroy
    Group.find(params[:id]).destroy
    flash[:success] = "Group destroyed."
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

end
