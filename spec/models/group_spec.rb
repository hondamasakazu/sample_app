require 'spec_helper'

describe Group do

  before { @group = Group.new(name: "Example Group", comment: "ほげほげコメント") }
  subject { @group }

  it { should respond_to(:name) }
  it { should respond_to(:comment) }
  it { should be_valid }

  describe "valid name" do

	  describe "not be_valid name" do
			before { @group.name = nil }
    	it { should_not be_valid }
	  end
	  describe "not be_valid name too orver" do
	    before { @group.name = "a" * 21 }
	    it { should_not be_valid }
	  end
	  describe "be_valid name too max" do
	    before { @group.name = "a" * 20 }
	    it { should be_valid }
	  end

  end

  describe "not be_valid comment" do

	  describe "not be_valid comment too orver" do
	    before { @group.comment = nil }
	    it { should_not be_valid }
	  end
	  describe "not be_valid comment too orver" do
	    before { @group.comment = "a" * 141 }
	    it { should_not be_valid }
	  end
	  describe "be_valid comment too max" do
	    before { @group.comment = "a" * 140 }
	    it { should be_valid }
	  end

  end

end
