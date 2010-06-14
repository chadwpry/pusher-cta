class PatternsController < ApplicationController

  def index
    @patterns = Pattern.first(:conditions => ["vrid = ?", params[:vehicle_route_id]])

    respond_to do |format|
      format.js { render :js => @patterns.to_json(:include => :points) }
    end
  end

  def show
    @pattern = Pattern.first(:conditions => [
      "pid = ?", params[:id]
    ])

    respond_to do |format|
      format.js { render :js => @pattern.to_json(:include => :points) }
    end
  end

end
