class VehicleRoutesController < ApplicationController

  # GET /vehicle_routes
  def index
    @vehicle_routes = VehicleRoute.all

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /vehicle_routes/:id/ping.js
  def ping
    @vehicle_route = VehicleRoute.first({
      :conditions => ["vrid = ?", params[:id]]
    })

    respond_to do |format|
      format.js  { render :js => "0" if @vehicle_route.list_locations.length > 0 }
    end
  end

end
