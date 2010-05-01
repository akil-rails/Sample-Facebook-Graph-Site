Fbgraph::Application.routes.draw do |map|
  resources :friends
  root :to => "friends#index"
end
