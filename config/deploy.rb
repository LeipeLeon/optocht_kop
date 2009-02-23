set :stages, %w(staging production)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

set :application, "optocht"

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


namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
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
    ['database', 'twitter','auth'].each {|yml_file|
      # remove  the git version of yml_file.yml
      run "if [ -e \"#{release_path}/config/#{yml_file}.yml\" ] ; then rm #{release_path}/config/#{yml_file}.yml; fi"

      # als shared conf bestand nog niet bestaat
      run "if [ ! -e \"#{deploy_to}/#{shared_dir}/config/#{yml_file}.yml\" ] ; then cp #{deploy_to}/#{shared_dir}/#{repository_cache}/config/#{yml_file}.example.yml #{deploy_to}/#{shared_dir}/config/#{yml_file}.yml; fi"

      # link to the shared yml_file.yml
      run "ln -nfs #{deploy_to}/#{shared_dir}/config/#{yml_file}.yml #{release_path}/config/#{yml_file}.yml" 
    }
  end
  after "deploy:symlink", "deploy:symlink_config"
end