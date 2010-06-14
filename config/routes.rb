ActionController::Routing::Routes.draw do |map|
  map.resources :vehicle_routes, :has_many => :patterns, :member => {
    :ping => :get
  }

  map.root :controller => 'vehicle_routes', :action => :index
end
