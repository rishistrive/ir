Rails.application.routes.draw do
  
  get 'section_types/index'

  get 'to_do_type/create'

  get 'to_do_type/index'

#
# CYA routes 
#
#  post 'cyas', :to => 'cyas#create'
#  patch 'cyas/:id', :to => 'cyas#update'
#  delete 'cyas/:id', :to => 'cyas#destroy'
#  get 'cyas/index'

#
# Rules routes 
#
  post 'rules', :to => 'rules#create'
  patch 'rules/:id', :to => 'rules#update'

# 
# Answer routes
#
  post 'answers', :to => 'answers#create'
  delete 'answers/:id', :to => 'answers#destroy'
  patch 'answers/:id', :to => 'answers#update'

#
# ToDo routes
#
  post 'to_dos', :to => 'to_dos#create'
  delete 'to_dos/:id', :to => 'to_dos#destroy'
  patch 'to_dos/update_answer_order/:id/', :to => 'to_dos#update_answer_order'
  
#
# Inspector statement routes
#
  get 'inspector_statements/index'
  get 'inspector_statements/', :to => 'inspector_statements#index'
  post 'inspector_statements', :to => 'inspector_statements#create'
  patch 'inspector_statements/:id', :to => 'inspector_statements#update'
  delete 'inspector_statements/:id', :to => 'inspector_statements#destroy'
  get 'inspector_statements/copy_library/:recipient_inspector_id', :to => 'inspector_statements#copy_library' #TODO: dear God, don't forget to comment this

#
# Template routes
#
  get 'inspection_templates/:id', :to => 'inspection_templates#show'
  get 'inspection_templates/index'
  get 'inspection_templates/', :to => 'inspection_templates#index'
  get 'inspection_templates/copy/:id', :to => 'inspection_templates#copy'  #TODO: should be a post
  get 'inspection_templates/:id/copy_template/:recipient_inspector_id', :to => 'inspection_templates#copy_to_another_inspector' #TODO: dear God, don't forget to comment this
  patch 'inspection_templates/:id', :to => 'inspection_templates#update'
  delete 'inspection_templates/:id', :to => 'inspection_templates#destroy'

#
# Section routes
#
  match 'sections/update_all/:id', :to => 'sections#update_all', :as => :update_all, :via => :patch #TODO: do I really need a match here?  Can I just say patch instead?
  match 'sections/update_all_images/:id', :to => 'sections#update_all_images', :as => :update_all_images, :via => :patch
  get '/reports/:id/sections/:id/', :to => 'sections#index'  #not sure I need this, given I have essentially the same route above
#  patch 'sections/update_cya_order/:id/', :to => 'sections#update_cya_order'
  patch 'sections/update_todo_order/:id/', :to => 'sections#update_todo_order'
  patch 'sections/:id', :to => 'sections#update'

#
# Report routes
#
  get 'reports/new', :to => 'reports#new'
  get 'reports/:id', :to => 'reports#show'
  patch 'reports/:id', :to => 'reports#update'
  get 'reports/:id/sections/', :to => 'reports#show_sections'
  delete 'reports/:id', :to => 'reports#destroy'
  delete 'reports/:id/cover_photo', :to => 'reports#delete_cover_photo'
  get 'reports/:id/rei/', :to => 'reports#create_rei'
  get 'reports/:id/preliminary_assessment/', :to => 'reports#create_preliminary_assessment'
  get 'reports/index'
  get 'reports/show'
  get 'reports', :to => 'reports#index'
  post 'reports/create', :to => 'reports#create'

  get '', :to => 'inspectors#show'
  get 'inspectors/index'
  get 'inspectors/edit'

=begin
  get 'rhythms/index'
  
  get 'rhythms/:id', :to => 'rhythms#show'
=end


  get 'access/logout'
  get 'access/login'
  post 'access/attempt_login'

  get 'inspectors/index'

  get 'admin', :to => 'access#index'
  
  delete 'statements/:id', :to => 'statements#destroy'
  patch 'statements/:id', :to => 'statements#update'
  post 'statements', :to => 'statements#create'
  post 'statements/create', :to => 'statements#create'
  
  get '/section_types', :to => 'section_types#index'
  patch 'section_types/:id/update_inspector_statement_order/', :to => 'section_types#update_inspector_statement_order' 
  
  post 'images', :to => 'images#create'
  
  patch 'images/:id', :to => 'images#update'
  
  delete 'images/:id', :to => 'images#destroy'
  
  delete 'answer_values/:id', :to => 'answer_values#destroy'
  
  #match ':controller(/:action(/:id))', :via => [:get, :post]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
