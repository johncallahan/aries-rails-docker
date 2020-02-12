AriesSdkRubyRailsFive::Application.routes.draw do
  root 'home#index'
  post 'home/create', to: 'home#create'
  post 'home/lookup', to: 'home#lookup'
end
