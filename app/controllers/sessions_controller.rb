class SessionsController < ApplicationController

	def new
	end

	def create
		user = User.find_by(email: params[:session][:email].downcase)
		if user &&
				user.authenticate(params[:session][:password]) &&
				user.confirm?
			sign_in user
			redirect_back_or user
		else
			flash.now[:error] = 'ログイン認証に失敗しました。入力情報をご確認ください。'
			render 'new'
		end
	end

	def destroy
    sign_out
    redirect_to root_url
	end

end
