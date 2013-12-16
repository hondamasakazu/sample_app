require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "サインイン画面 異常系" do
    before { visit signin_path }

    describe "認証エラー時に、画面出力されるエラー文字列の確認" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_error_message('Invalid') }

      describe "認証エラー後、ホーム画面にエラー文字列が表示されないことを確認" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
        it { should_not have_link('Users') }
        it { should_not have_link('Profile') }
        it { should_not have_link('Settings') }
        it { should_not have_link('Sign out',    href: signout_path) }
        it { should have_link('Sign in', href: signin_path) }
      end
    end

    describe "ログイン成功後に表示されるユーザー情報画面の各リンクの表示確認" do
      let(:user) { FactoryGirl.create(:user) }
      before { valid_signin(user) }

      it { should have_title(user.name) }
      it { should have_link('Users',       href: users_path) }
      it { should have_link('Profile',     href: user_path(user)) }
      it { should have_link('Settings',    href: edit_user_path(user)) }
      it { should have_link('Sign out',    href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }
    end
  end

  describe "サインイン画面 正常系" do

    describe "認証前（ログイン前）" do
      let(:user) { FactoryGirl.create(:user) }

      describe "未ログイン状態で各アクションを確認" do

        describe "ユーザー一覧のパスを指定するがログインしてないので、ログイン画面を表示" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "保護されたページを訪問する（フレンドリーフォワーディング）" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "ログイン前に指定した画面（ユーザー情報編集）への画面遷移確認" do
            it "レンダリング結果" do
              expect(page).to have_title('Edit user')
            end
          end
        end

        describe "ユーザー情報編集のパスを指定するが（ログインしてないのでログイン画面へ" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "ユーザー情報更新時のリダイレクト先の確認（ログイン前）" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end

      describe "ユーザー情報の偽装" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user, no_capybara: true }

        describe "偽装したユーザー情報で編集アクションにGET(取得）リクエストを送信する" do
          before { get edit_user_path(wrong_user) }
          specify { expect(response.body).not_to match(full_title('Edit user')) }
          specify { expect(response).to redirect_to(root_url) }
        end

        describe "偽装したユーザー情報で編集アクションにPATCH(更新）リクエストを送信する" do
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end

      describe "in the Microposts controller" do

        describe "submitting to the create action" do
          before { post microposts_path }
          specify { expect(response).to redirect_to(signin_path) }
        end

        describe "submitting to the destroy action" do
          before { delete micropost_path(FactoryGirl.create(:micropost)) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "管理者権限以外のユーザーとしてログイン" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "管理者権限以外のユーザーユーザーへのDELETE要求を送信＃" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end
end