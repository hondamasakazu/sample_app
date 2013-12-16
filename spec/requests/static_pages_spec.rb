require 'spec_helper'

describe "Static pages" do

  subject { page }
  describe "Home" do
    before { visit root_path }
    it { should have_content('Future-Commynity') }
    it { should have_title(full_title('')) }
    it { should have_title('Home') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "ほげほげ")
        FactoryGirl.create(:micropost, user: user, content: "ふがふが")
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    end

    describe "count micropost" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "ほげほげ")
        sign_in user
        visit root_path
      end

      it { should have_content("#{user.microposts.count} micropost") }
      describe "count microposts" do
        before do
          FactoryGirl.create(:micropost, user: user, content: "ほげほげ")
          FactoryGirl.create(:micropost, user: user, content: "ほげほげ")
          sign_in user
          visit root_path
        end
        it { should have_content("#{user.microposts.count} microposts") }
      end
    end
    describe "pagination" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        31.times { FactoryGirl.create(:micropost, user: user) }
        sign_in user
        visit root_path
      end

      it { should have_selector('div.pagination') }

      it "各icropost表示" do
        user.feed.paginate(page: 1).each do |micropost|
          expect(page).to have_selector('li', text: micropost.content)
        end
      end
    end

    describe "delete links" do
      let(:user) { FactoryGirl.create(:user) }

      before(:each) do
        FactoryGirl.create(:micropost, user: user)
        sign_in user
        visit root_path
      end
      it { should have_link('delete') }

      describe "カレントユーザー以外は削除リンクなし" do
        let(:otheruser) { FactoryGirl.create(:user) }
        it { should_not have_link('delete', href: user_path(otheruser)) }
      end
    end

  end

  describe "Help page" do
    before { visit help_path }
    it { should have_title(full_title('')) }
    it { should have_title('Help') }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }
    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end

end