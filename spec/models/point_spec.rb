require 'spec_helper'

describe Point do
  describe "instantiating an object with no parameters" do
    it { should have(2).errors_on(:pid) }
    it { should have(2).errors_on(:sequence) }
    it { should have(1).errors_on(:lat) }
    it { should have(1).errors_on(:lon) }
    it { should have(2).errors_on(:pttype) }
#    it { should have(1).errors_on(:distance) }
  end

  describe "instantiating an object with valid parameters" do
    before(:each) do
      @valid_attributes = {
        :pid => 1,
        :sequence => 1,
        :lat => 41.90843000866118,
        :lon => -87.63318634033203,
        :pttype => 'S',
        :stid => 1,
        :stname => 'Morse &amp; Lakewood',
        :distance => 438.0
      }
    end

    it "should create a new instance given valid attributes" do
      Point.new(@valid_attributes).should be_valid
    end
  end
end
