role :app, "c"
role :web, "c"
role :db,  "c", :primary => true
set :user, 'root'

set :deploy_to, "/var/www/apps/#{application}"
