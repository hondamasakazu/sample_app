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
      end
    end # "サインイン画面 異常系" end

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
  end # "サインイン画面" end

  describe "サインイン画面 正常系" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "サインイン後の動作確認" do

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_title('Sign in') }
        end

        describe "when attempting to visit a protected page" do
          before do
            visit edit_user_path(user)
            fill_in "Email",    with: user.email
            fill_in "Password", with: user.password
            click_button "Sign in"
          end

          describe "after signing in" do

            it "should render the desired protected page" do
              expect(page).to have_title('Edit user')
            end
          end
        end

        describe "ユーザー情報編集画面遷移の確認" do
          before { visit edit_user_path(user) }
          it { should have_title('Sign in') }
        end

        describe "ユーザー情報更新時のリダイレクト先の確認" do
          before { patch user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end # "サインイン後の動作確認" end

      describe "サインイン時に生成されたセッション情報とは違うユーザーでユーザー情報を更新した場合の確認" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        before { sign_in user, no_capybara: true }

        describe "submitting a GET request to the User#edit action" do
          before { patch user_path(wrong_user) }
          specify { expect(response).to redirect_to(root_path) }
        end
      end
    end # "for non-signed-in users" end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin, no_capybara: true }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end # "as non-admin user" end
  end # "サインイン画面 正常系" end
end