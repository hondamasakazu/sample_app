require 'spec_helper'

describe "StaticPages" do

  describe "Home pages" do
    it "should have the content 'Sample App'" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      visit '/static_pages/home'
      expect(page).to have_content('Sample App')
    end
   it "should have the rigth title" do
     visit '/static_pages/home'
     expect(page).to have_title('Ruby on Rails Tutorial Sample App | Home')
   end
  end

  describe "Help Pages" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
   it "should have the rigth title" do
     visit '/static_pages/help'
     expect(page).to have_title('Ruby on Rails Tutorial Sample App | Help')
   end
  end

  describe "About page" do
    it "should have th content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content('About')
    end
   it "should have the rigth title" do
     visit '/static_pages/about'
     expect(page).to have_title('Ruby on Rails Tutorial Sample App | About')
   end
  end

end
