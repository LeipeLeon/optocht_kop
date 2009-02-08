set :application, "optocht"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/apps/#{application}"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
set :scm, :git
default_run_options[:pty] = true
set :repository, "git@github.com:LeipeLeon/optocht.git"
# set :repository, "file://."
set :repository_cache, "git_master"
set :deploy_via, :remote_cache
# set :deploy_via, :copy
set :branch, "master"
set :scm_verbose, :true
# set :user, 'root'
# set :ssh_options, { :forward_agent => true }
set :use_sudo, false

set :chmod777, %w(public/thumb public log)

role :app, "c"
role :web, "c"
role :db,  "c", :primary => true

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
      "chmod 777 -R #{current_path}/#{item}"
    end.join(" && "))
  end

  desc "Create shared/config" 
  task :after_setup do
    # copy dev version of database.yml to alter later
    run "if [ ! -d \"#{deploy_to}/#{shared_dir}/config\" ] ; then mkdir #{deploy_to}/#{shared_dir}/config ; fi"
  end

  desc "Link to database.yml in shared/config" 
  task :symlink_config do
    # remove  the git version of database.yml
    run "if [ -e \"#{release_path}/config/database.yml\" ] ; then rm #{release_path}/config/database.yml; fi"
    run "if [ -e \"#{release_path}/config/twitter.yml\" ] ; then rm #{release_path}/config/database.yml; fi"

    # als shared conf bestand nog niet bestaat
    run "if [ ! -e \"#{deploy_to}/#{shared_dir}/config/database.yml\" ] ; then cp #{deploy_to}/#{shared_dir}/#{repository_cache}/config/database.yml #{deploy_to}/#{shared_dir}/config/database.yml ; echo \"REMEMBER TO ALTER THE DATABASE SETUP!!!\"; fi"
    run "if [ ! -e \"#{deploy_to}/#{shared_dir}/config/twitter.yml\" ] ; then cp #{deploy_to}/#{shared_dir}/#{repository_cache}/config/database.yml #{deploy_to}/#{shared_dir}/config/twitter.yml; fi"

    # link to the shared database.yml
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/database.yml #{release_path}/config/database.yml" 
    run "ln -nfs #{deploy_to}/#{shared_dir}/config/twitter.yml #{release_path}/config/twitter.yml" 
  end
  after "deploy:symlink", "deploy:symlink_config"
end