class UsersController < ApplicationController
  before_action :signed_in_user, only: [:index, :edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  # ユーザー一覧
  def index
    @users = User.paginate(page: params[:page])
  end

  # アカウント情報表示画面
  def show
    @user = User.find(params[:id])
  end

  # アカウント登録画面表示
  def new
    @user = User.new
  end

  # アカウント認証
  def create
    @user = User.new(user_params)
    if @user.save
      sign_in @user # ユーザトークン発行と保存
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # ユーザー情報編集画面表示
  def edit
  end

  # ユーザー情報更新
  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user # @userを解析し、'/users/:id'にリダイレクト
    else
      render 'edit'
    end
  end

  # ユーザー削除
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

# Before actions

    # 認証済みかどうか確認
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
=begin
      上記処理を冗長的に記載すると下記になる
      unless signed_in?
        flash[:notice] = "Please sign in."
        redirect_to signin_url
      end
=end
    end
    # Session偽装チェック
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
