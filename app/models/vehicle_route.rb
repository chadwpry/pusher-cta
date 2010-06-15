class VehicleRoute < ActiveRecord::Base

  # CONSTANTS
  NORTH_BOUND = "North Bound"
  SOUTH_BOUND = "South Bound"

  # INCLUDES

  # ASSOCIATIONS
  set_primary_key "vrid"
  has_many :vehicles,  :primary_key => :vrid, :foreign_key => :vrid
  has_many :locations, :foreign_key => :vrid
  has_many :patterns,  :foreign_key => :vrid

  # MIXINS

  # VALIDATIONS
  validates_presence_of     :vrid, :name
  validates_length_of       :vrid,  :maximum => 10
  validates_uniqueness_of   :vrid

  # INSTANCE METHODS
  def latest_vehicle_document(vehicle_list)
    options = { :conditions => ["vrid = ?", vrid], :order => 'created_at asc', :limit => 1 }
    options.merge!(:vid => ["vid in ?", vehicle_list]) unless vehicle_list.empty?

    url = "#{CTA_SERVER}/getvehicles?key=#{CTA_API_KEY}&rt=#{vrid}"
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

  def list_locations(session_id)
    import_locations unless cached?

    Location.all(:conditions => ["vrid = ? and active = ?", vrid, true]).each do |location|
      notify_pusher(location, session_id)
    end
  end

  def cached?
    location = Location.first(:conditions => ["vrid = ?", vrid], :order => 'created_at desc')
    if location
      location.older_than?(30.seconds)
    else
      false
    end
  end

  def import_patterns(pattern_list = [])
    latest_pattern_document(pattern_list).xpath("//bustime-response/ptr").each do |pattern|

      Pattern.delete_all(["pid = ?", pattern.search("pid").text.strip])
      Point.delete_all(["pid = ?", pattern.search("pid").text.strip])

      puts "vrid: #{vrid} pid: #{pattern.search("pid").text.strip}"

      persisted_pattern = Pattern.new({
        :pid       => pattern.search("pid").text.strip,
        :vrid      => vrid,
        :length    => pattern.search("ln").text.strip,
        :direction => pattern.search("rtdir").text.strip
      })
      persisted_pattern.pid = pattern.search("pid").text.strip

      if persisted_pattern.save
        pattern.search("pt").each do |point|
          options = {
            :pid => persisted_pattern[:pid],
            :sequence => point.search("seq").text.strip,
            :lat => point.search("lat").text.strip,
            :lon => point.search("lon").text.strip,
            :pttype => (point.search("typ").text.strip.empty? ? 'W' : point.search("typ").text.strip)
          }
          options.merge!({
            :stid => point.search("stpid").text.strip,
            :stname => point.search("stpnm").text.strip,
            :distance => point.search("pdist").text.strip
          }) if options[:pttype] == 'S'

          Point.create!(options)
        end
      end
    end
  end

  def latest_pattern_document(pattern_list)
    options = { :conditions => ["vrid = ?", vrid], :order => 'created_at asc', :limit => 1 }
    options.merge!(:pid => ["pid in ?", pattern_list]) unless pattern_list.empty?

    url = "#{CTA_SERVER}/getpatterns?key=#{CTA_API_KEY}&rt=#{vrid}"
    Nokogiri::XML::Document.parse(open(url))
  end

  def notify_pusher(location, session_id = "")
    Pusher["vehicle_route_#{session_id}#{location.vrid.to_s}"].trigger("location_move", {
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
    })
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
    Nokogiri::XML::Document.parse(open("#{CTA_SERVER}/getroutes?key=#{CTA_API_KEY}"))
  end

end
