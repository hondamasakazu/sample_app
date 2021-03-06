require 'spec_helper'

describe User do
  before { @user = User.new(name: "Example User", email: "user@fexd.co.jp",
                        password: "foobar", password_confirmation: "foobar") }
  subject{ @user}

  it { should respond_to(:name)}
  it { should respond_to(:email)}
  it { should respond_to(:password_digest)}
  it { should respond_to(:password)}
  it { should respond_to(:password_confirmation)}
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "ADMIN属性'true'" do
    before do
      @user.save!
      @user.toggle!(:admin) # 属性を反転させる
    end

    it { should be_admin }
  end

  describe "名前が存在しない場合" do
  	before { @user.name = " "}
  	it { should_not be_valid }
  end

  describe "emailが存在しない場合" do
  	before { @user.email = " "}
  	it { should_not be_valid }
  end

  describe "名前のLegthチェック" do
  	before { @user.name = "a" * 31}
  	it { should_not be_valid }
  end

  describe "Mailフォーマット：系" do

    it "should invalid" do
      addresses = %w[
        user@foo,com
        user_at_foo.org
        example_user@foo.foo@bar.com
        foo@bar+baz.com,
        foo@bar..com]

      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end

  end

  describe "Mailフォーマット：正常系" do
    it "should valid" do
      addresses = %w[user@fexd.CO.jp A_US-ER@fexd.co.jp frst.lst@fexd.co.jp a+b@fexd.co.jp]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "mail重複チェック（upcase）" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    it { should_not be_valid}
  end

  describe "パスワードがブランク" do
    before do
      @user =  User.new(name: "Example User", email: "user@fexd.co.jp",
                    password: " ", password_confirmation: " ")
    end
    it { should_not be_valid }
  end

  describe "パスワードとコンファームのミスマッチ" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "パスワード最小値" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end

  describe "ユーザー情報保存" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "パスワード認証メソッド確認" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "パスワード認証メソッド確認：エラー" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "アドレスのlower-case保存確認" do
    let(:mixed_case_email) { "Foo@FexD.CO.Jp" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase!
    end
  end

  describe "remember token発行確認" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end

    it "should destroy associated microposts" do
      microposts = @user.microposts.to_a # 参照コピー
      @user.destroy
      expect(microposts).not_to be_empty # 参照コピーだから破棄されない
      microposts.each do |micropost|
        expect(Micropost.where(id: micropost.id)).to be_empty # 参照コピーしたmicropost.idからDB検索
      end
      # Findの場合は下記のようにする
      # expect do
      #   Micropost.find(micropost)
      # end.to raise_error(ActiveRecord::RecordNotFound)
    end
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end
end
