Rails.application.routes.draw do

  get 'schedule/read'

  get 'schedule/update'

  post 'schedule/updateItem'

  get 'search' => 'search#find'

  get 'article/create'
  get 'article/read/:id' => 'article#read'
  post 'article/update/:id' => 'article#update'
  get 'article/delete'
  post 'article/new'

  post 'group/update'
  get 'group/view'

  get 'discipline/create'
  get 'discipline/read/:id' => 'discipline#read'
  get 'discipline/listMaterials/:id' => 'discipline#listMaterials'
  get 'discipline/listPublications/:id' => 'discipline#listPublications'
  get 'discipline/listDisciplines.json' => 'discipline#listDisciplines'

  post 'discipline/new'
  post 'discipline/update/:id' => 'discipline#update'
  post 'discipline/delete/:id' => 'discipline#delete'


  get 'materials/download/:id' => 'materials#download'
  get 'materials/create'
  get 'materials/read/:id' => 'materials#read'
  get 'materials/list_materials'
  post 'materials/delete/:id' => 'materials#delete'
  post 'materials/create'
  post 'materials/update/:id' => 'materials#update'

  get 'user/login' => 'user#create'
  post 'user/login'

  get 'user/read/:id' => 'user#read'

  get 'user/update/:id' => 'user#update'
  post 'user/update/:id' => 'user#updatePOST'

  get 'user/delete/:id' => 'user#delete'
  get 'user/logout'
  get 'user/list'

  root to: 'group#view'

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
