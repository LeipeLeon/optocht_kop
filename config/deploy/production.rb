role :app, "webp"
role :web, "webp"
role :db,  "webp", :primary => true
set :user, 'pamlol'

set :deploy_to, "/home/pamlol/#{application}"
