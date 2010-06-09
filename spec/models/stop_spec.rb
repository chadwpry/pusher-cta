require 'spec_helper'

describe Stop do
  describe "instantiating an object with no parameters" do
    it { should have(2).errors_on(:stid) }
    it { should have(2).errors_on(:vrid) }
    it { should have(1).errors_on(:direction) }
    it { should have(1).errors_on(:name) }
    it { should have(1).errors_on(:lat) }
    it { should have(1).errors_on(:lon) }
  end

  describe "instantiating an object with valid parameters" do
    before(:each) do
      @valid_attributes = {
        :stid => 1,
        :vrid => 1,
        :direction => 'South Bound',
        :name => "value for name",
        :lat => 41.91519784927368,
        :lon => -87.63271141052246
      }
    end

    it "should create a new instance given valid attributes" do
      Stop.new(@valid_attributes).should be_valid
    end
  end
end
