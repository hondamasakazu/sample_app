class UsersController < ApplicationController
  before_action :signed_in_user,  only: [:index, :edit, :update]
  before_action :correct_user,    only: [:edit, :update]
  before_action :signed_in,       only: [:new, :create]
  before_action :admin_user,      only: :destroy

  # ユーザー一覧
  def index
    @users = User.paginate(page: params[:page])
  end

  # アカウント情報表示画面
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  # アカウント登録画面表示
  def new
    @user = User.new
  end

  # ユーザー情報編集画面表示
  def edit
  end

  # アカウント作成
  def create
    @user = User.new(user_params)
    if @user.save
      # sign_in @user # ユーザトークン発行と保存
      UserRegistration.sendmail_confirm(@user).deliver
      render 'confirm'
      #redirect_to @user
    else
      render 'new'
    end
  end

  def confirm
    # ここの処理ちょー微妙かも。。。。パスをURLに付けた。これはセキュリティー上NG!
    # 後々、パスワードは再度入力してもらってから更新する処理へ変更する！
    @user = User.find_by(remember_token: params[:confirm_token])
    @user.password = params[:pass];
    @user.password_confirmation = params[:pass];
    @user.confirm = true
    if @user.save
      sign_in @user # ユーザトークン発行と保存
      flash.now[:success] = "Welcome to the FutureCommynity!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # ユーザー情報更新
  def update
    if @user.update_attributes(user_params)
      flash.now[:success] = "Profile updated"
      redirect_to @user # @userを解析し、'/users/:id'にリダイレクト
    else
      render 'edit'
    end
  end

  # ユーザー削除
  def destroy
    User.find(params[:id]).destroy
    flash.now[:success] = "User destroyed."
    redirect_to users_url
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

# Before actions
    # Session偽装チェック
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

    def signed_in
      redirect_to(root_path) if signed_in?
    end

end
