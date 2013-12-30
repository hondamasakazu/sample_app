module SessionsHelper

  # 暗号化トークンの発行と保存
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end

  # カレントユーザの設定
  def current_user=(user)
    @current_user = user
  end

  # カレントユーザの取得
  def current_user
    remember_token = User.encrypt(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  # 認証確認
  def signed_in?
    !current_user.nil? && current_user.confirm?
  end

  # 成りすましチェック
  def current_user?(user)
    user == current_user
  end

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

  # ログアウト
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

  # フレンドリーフォワーディング
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  # フレンドリーフォワーディング
  def store_location
    session[:return_to] = request.url
  end

end
