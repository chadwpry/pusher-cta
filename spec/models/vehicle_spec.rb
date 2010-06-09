require 'spec_helper'

describe Vehicle do
  describe "instantiating an object with no parameters" do
    it { should have(2).errors_on(:vid) }
    it { should have(2).errors_on(:vrid) }
  end

  describe "instantiating an object with valid parameters" do
    before(:each) do
      @valid_attributes = {
        :vid => 1,
        :vrid => 1
      }
    end

    it "should create a new instance given valid attributes" do
      Vehicle.new(@valid_attributes).should be_valid
    end
  end
end
