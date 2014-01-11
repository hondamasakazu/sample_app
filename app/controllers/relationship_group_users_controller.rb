class RelationshipGroupUsersController < ApplicationController
	before_action :signed_in_user

	def create
    @group = Group.find(params[:relationship_group_user][:group_id])
    @user = User.find(params[:relationship_group_user][:user_id])
    @user.join_groups!(@group)
    flash[:success] = "#{@group.name}へ#{@user.name}さんを追加しました。"
    redirect_to @group
  end

  def destroy
    @group  = RelationshipGroupUser.find(params[:id]).group
    @user = User.find(params[:relationship_group_user][:user_id])
    @user.unjoin_groups!(@group)
    redirect_to @group
  end
=begin
Ajax対応したみたけど、上手くいかない。。。一旦コメントアウト

  def create
    @group = Group.find(params[:relationship_group_user][:group_id])
    @user = User.find(params[:relationship_group_user][:user_id])
    @user.join_groups!(@group)
    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end

  def destroy
    @group  = RelationshipGroupUser.find(params[:id]).group
    @user = User.find(params[:relationship_group_user][:user_id])
    @user.unjoin_groups!(@group)
    respond_to do |format|
      format.html { redirect_to @group }
      format.js
    end
  end
=end
end
