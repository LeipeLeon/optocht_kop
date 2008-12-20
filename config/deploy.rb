set :application, "optocht"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/nl/pampus-lollebroek/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
default_run_options[:pty] = true
set :repository, "ssh://web//var/www/git/optocht"
# set :repository, "file://."
set :repository_cache, "git_master"
set :deploy_via, :remote_cache
# set :deploy_via, :copy
set :branch, "master"
set :scm_verbose, :true
# set :user, 'root'
# set :ssh_options, { :forward_agent => true }
set :use_sudo, false

role :app, "web"
role :web, "web"
role :db,  "web", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end