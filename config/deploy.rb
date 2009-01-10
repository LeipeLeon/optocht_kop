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

set :chmod777, %w(public/thumb)

role :app, "root@192.168.134.196"
role :web, "root@192.168.134.196"
role :db,  "root@192.168.134.196", :primary => true
# role :app, "web"
# role :web, "web"
# role :db,  "web", :primary => true

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
  
  [:import, :export].each do |t|
    desc "#{t} content for comatose, do a deploy first"
    task ('coma_'+t.to_s).to_sym, :roles => :app do 
      rake = fetch(:rake, "rake")
      rails_env = fetch(:rails_env, "production")

      run "cd #{current_release}; #{rake} RAILS_ENV=#{rails_env} comatose:data:#{t}"
    end
  end

  desc "Set the proper permissions for directories and files"
  task :before_restart do
    run(chmod777.collect do |item|
      "chmod 777 #{current_path}/#{item}"
    end.join(" && "))
  end

  desc "Create database.yml in shared/config" 
  task :after_deploy do

    # remove  the dev version of database.yml
    run "rm #{release_path}/config/database.yml"
  
    # link to the database.yml
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
  end
end