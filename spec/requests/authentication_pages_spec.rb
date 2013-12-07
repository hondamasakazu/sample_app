require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "サインイン画面" do
    before { visit signin_path }

    describe "認証エラー時に、画面出力されるエラー文字列の確認" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }

      describe "認証エラー後、ホーム画面にエラー文字列が表示されないことを確認" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end # "with invalid information" end

    describe "ログイン成功後に表示されるユーザー情報画面の各リンクの表示確認" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end # "signin page" end
end