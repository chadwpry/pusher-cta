require 'spec_helper'

describe Pattern do
  describe "instantiating an object with no parameters" do
    it { should have(2).errors_on(:pid) }
    it { should have(2).errors_on(:vrid) }
    it { should have(2).errors_on(:length) }
    it { should have(1).errors_on(:direction) }
  end

  describe "instantiating an object with valid parameters" do
    before(:each) do
      @valid_attributes = {
        :pid => "1",
        :vrid => "1",
        :length => 1.5,
        :direction => "value for direction"
      }
    end

    it "should create a new instance given valid attributes" do
      pattern = Pattern.new(@valid_attributes)
      pattern.pid = @valid_attributes[:pid]
      pattern.should be_valid
    end
  end
end
