require 'spec_helper'

describe RelationshipGroupUser do

  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }

  describe "relationship_group_users for user" do
	  before { @relationship_group_users = user.relationship_group_users.build }
	  subject { @relationship_group_users }

	  it { should respond_to(:group_id) }
	  it { should respond_to(:user_id) }
	  it { should respond_to(:user) }
	  its(:user) { should eq user }
	  it { should_not be_valid }

	  describe "for create" do
			before do
		   @relationship_group_users = user.relationship_group_users.create!(group_id: group.id)
			end
		  subject { @relationship_group_users }

		  it { should respond_to(:group_id) }
		  it { should respond_to(:user_id) }
		  it { should respond_to(:group) }
		  its(:user) { should eq user }
		  its(:group) { should eq group }
		  it { should be_valid }

		  describe "join" do
		  	let(:group_etc) { FactoryGirl.create(:group) }
				before do
			  	@relationship_group_users = user.join_groups!(group_etc)
				end
			  subject { @relationship_group_users }

			  it { should respond_to(:group_id) }
			  it { should respond_to(:user_id) }
			  it { should respond_to(:group) }
			  its(:user) { should eq user }
			  its(:group) { should eq group_etc }
			  it { should be_valid }

			  describe "un join" do
					before do
				  	user.unjoin_groups!(group_etc)
					end
					subject { user }
				  its(:join_groups) { should include(group_etc) }
			  end
		  end
	  end
  end

  describe "relationship_group_users for group" do
	  before { @relationship_group_users = group.relationship_group_users.build }
	  subject { @relationship_group_users }

	  it { should respond_to(:group_id) }
	  it { should respond_to(:user_id) }
	  it { should respond_to(:group) }
	  its(:group) { should eq group }
	  it { should_not be_valid }

	  describe "for create" do
			before do
		   @relationship_group_users = group.relationship_group_users.create!(user_id: user.id)
			end
		  subject { @relationship_group_users }

		  it { should respond_to(:group_id) }
		  it { should respond_to(:user_id) }
		  it { should respond_to(:group) }
		  its(:user) { should eq user }
		  its(:group) { should eq group }
		  it { should be_valid }
	  end
  end

end
