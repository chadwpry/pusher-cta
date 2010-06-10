class VehicleRoute < ActiveRecord::Base

  # CONSTANTS
  NORTH_BOUND = "North Bound"
  SOUTH_BOUND = "South Bound"

  # INCLUDES

  # ASSOCIATIONS
  has_many :vehicles, :primary_key => 'vrid', :foreign_key => 'vrid'

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :vrid, :name
  validates_length_of       :vrid,  :maximum => 10
  validates_uniqueness_of   :vrid

  # INSTANCE METHODS
  def latest_vehicle_document(vehicle_list)
    options = { :conditions => ["vrid = ?", vrid], :order => 'created_at asc', :limit => 1 }
    options.merge!(:vid => ["vid in ?", vehicle_list]) unless vehicle_list.empty?

    url = "#{CTA[:server]}/getvehicles?key=#{CTA[:api_key]}&rt=#{vrid}"
    Nokogiri::XML::Document.parse(open(url))
  end

  def import_locations(vehicle_list = [])
    latest_vehicle_document(vehicle_list).xpath("//bustime-response/vehicle").each do |vehicle|
      vrid      = vehicle.search("rt").text.strip
      vid       = vehicle.search("vid").text.strip
      pid       = vehicle.search("pid").text.strip
      timestamp = vehicle.search("tmstmp").text.strip
      heading   = vehicle.search("hdg").text.strip
      dest      = vehicle.search("des").text.strip
      pdistance = vehicle.search("pdist").text.strip
      lat       = vehicle.search("lat").text.strip.to_f
      lon       = vehicle.search("lon").text.strip.to_f

      vehicle  = Vehicle.find_or_create_by_vid(vid)
      location = Location.find_or_create_by_vid_and_lat_and_lon(vid, lat, lon)

      if location.new_record?
        location.vrid        = vrid
        location.pid         = pid
        location.pdistance   = pdistance
        location.timestamp   = timestamp
        location.heading     = heading
        location.destination = dest
        location.save

        Location.update_all(["active = ?", false], ["vid = ? and active = ? and id != ?", vid, true, location.id])
      end
    end
  end

  def list_locations
    import_locations unless cached?

    Location.all(:conditions => ["vrid = ? and active = ?", vrid, true]).each do |location|
      notify_pusher(location)
    end
  end

  def cached?
    Location.first(:conditions => ["vrid = ?", vrid], :order => 'created_at desc').older_than?(30.seconds)
  end

  def notify_pusher(location)
    message = {
      :vehicle => {
        :vid => location.vid,
        :timestamp => location.timestamp, :heading => location.heading,
        :destination => location.destination, :delayed => location.delayed,
        :lat => location.lat, :lon => location.lon,
        :pattern => {
          :pid => location.pid, :distance => location.pdistance
        },
        :route => {
          :vrid => location.vrid
        }
      }
    }

    puts "message: #{message.inspect}"
    Pusher["vehicle_route_#{location.vehicle_route.vrid.to_s}"].trigger("location_move", message)
  end

  # CLASS METHODS
  def self.import_cta
    latest_route_document.xpath("//bustime-response/route").each do |route|
      name = route.search("rtnm").text.strip
      route = VehicleRoute.find_or_create_by_vrid(route.search("rt").text.strip)
      route.update_attributes(:name => name) if route.new_record? || route.name != name
    end
  end

  def self.latest_route_document
    Nokogiri::XML::Document.parse(open("#{CTA[:server]}/getroutes?key=#{CTA[:api_key]}"))
  end

end
