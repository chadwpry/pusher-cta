require 'spec_helper'

describe VehicleRoute do
  describe "instantiating an object with no paramters" do
    it { should have(2).errors_on(:vrid) }
    it { should have(1).errors_on(:name) }
  end

  describe "instantiating an object with valid parameters" do
    before(:each) do
      @valid_attributes = {
        :vrid => "1",
        :name => "value for name"
      }
    end

    it "should create a new instance given valid attributes" do
      vehicle_route = VehicleRoute.new(@valid_attributes)
      vehicle_route.vrid = @valid_attributes[:vrid]
      vehicle_route.should be_valid
    end
  end
end
