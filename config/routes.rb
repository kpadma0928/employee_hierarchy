Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  post '/create_employee_details', to: 'employees#create_employee_details'
  get '/hierarchy/:designation', to: 'employees#hierarchy'
  delete '/delete_employee/:emp_code', to: 'employees#delete_employee'
  get '/top_10_employees', to: 'employees#top_10_employees'
end
