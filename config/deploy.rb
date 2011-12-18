require 'bundler/capistrano'
#using  RVM!
$:.unshift("#{ENV["HOME"]}/.rvm/lib")
require "rvm/capistrano"
set :rvm_type, :user


set :application, "capi_app"
set :deploy_to, "/var/www/#{application}"

role :web, "50.18.174.75"                          # Your HTTP server, Apache/etc
role :app, "50.18.174.75"                         # This may be the same as your `Web` server
role :db,  "50.18.174.75", :primary => true # This is where Rails migrations will run


default_run_options[:pty] =  true
set :repository,  "git@github.com:jaipratik/store3.git"
set :scm, :git
set :branch, "master"


set :user, "ubuntu"            
set :use_sudo, false
set :admin_runner, "ubuntu"

set :rails_env, 'production'     
#set :use_sudo, false   #if error delete this


# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  
  task :spree_site, :roles => :db, :only =>{:primary => true} do
   run "RAILS_ENV=#{rails_env} bundle exec rails g spree:site -A"
   run "RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
   run "RAILS_ENV=#{rails_env} bundle exec rake db:seed"
   
  end
  
  task :stop do ; end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  
  end
end


