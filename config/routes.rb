ActionController::Routing::Routes.draw do |map|
#  map.resources :locations
  map.resources :vehicle_routes, :member => { :ping => :get }

#  map.connect ':controller/:action/:id'
#  map.connect ':controller/:action/:id.:format'

  map.root :controller => 'vehicle_routes', :action => :index
end