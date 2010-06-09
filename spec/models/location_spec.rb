require 'spec_helper'

describe Location do
  describe "instantiating an object with no parameters" do
    it { should have(2).errors_on(:vid) }
    it { should have(2).errors_on(:vrid) }
    it { should have(2).errors_on(:pid) }
    it { should have(1).errors_on(:pdistance) }
    it { should have(1).errors_on(:timestamp) }
    it { should have(1).errors_on(:heading) }
    it { should have(1).errors_on(:destination) }
    it { should have(1).errors_on(:lat) }
    it { should have(1).errors_on(:lon) }
  end

  describe "instantiating an object with valid parameters" do
    before(:each) do
      @valid_attributes = {
        :vid => "4019",
        :vrid => 156,
        :pid => 4536,
        :pdistance => 14594,
        :timestamp => "20100608 16:24",
        :heading => "178",
        :destination => "Desplaines/Harrison",
        :lat => 41.90843000866118,
        :lon => -87.63318634033203
      }
    end

    it "should create a new instance given valid attributes" do
      Location.new(@valid_attributes).should be_valid
    end
  end
end
