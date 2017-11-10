Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homepage#index"
  post '/import_excel', to: 'homepage#import_excel'

end
