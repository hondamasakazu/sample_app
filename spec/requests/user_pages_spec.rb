require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }

      it { should have_selector('div.pagination') }

      it "各ユーザーを一覧表示" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      let(:user) { FactoryGirl.create(:user) }
      before(:each) do
        sign_in user
        visit users_path
      end
      it { should_not have_link('delete') }

      describe "Adminユーザーで認証" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "Adminユーザーでユーザー削除確認" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "signup page" do
  	before { visit signup_path }

	it { should have_content('Sign up') }
  it { should have_button("Create my account") }
	it { should have_title(full_title('Sign up')) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }

    before do
      sign_in user
      visit user_path(user)
    end
    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
  end

  describe "ログイン" do

    before { visit signup_path }
    let(:submit) { "Create my account" }

    describe "無効なユーザー情報（ブランク）を送信" do
      it "情報が登録されていないことを確認" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "無効なユーザー情報（ブランク）を送信後、画面表示確認" do
        before { click_button submit }
        it { should have_title('Sign up') }
        it { should have_error_message('error') }
      end
    end

    describe "認証時に有効なユーザー情報を生成" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirm Password", with: "foobar"
      end

      it "ユーザー情報を登録" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "ユーザー情報を登録" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end

      describe "ユーザーを保存した後のログアウトのリンク等確認" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }

        describe "ログアウト" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_button("Save changes") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "更新時のバリデートエラー" do
      before { click_button "Save changes" }

      it { should have_error_message('error') }
    end

    describe "更新処理" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "一般ユーザーがAdminユーザーへ更新する。Admin属性が更新できないことを確認" do
      let(:params) do
        { user: { admin: true, password: user.password,
                  password_confirmation: user.password } }
      end
      before do
        sign_in user, no_capybara: true
        patch user_path(user), params
      end
      specify { expect(user.reload).not_to be_admin }
    end
  end # "edit" end
end
