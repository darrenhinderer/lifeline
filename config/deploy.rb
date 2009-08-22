default_run_options[:pty] = true
set :application, "rr09-team-199"
set :repository, "git@github.com:railsrumble/rr09-team-199.git"

role :app, "magpie.r09.railsrumble.com"
role :web, "magpie.r09.railsrumble.com"
role :db, "magpie.r09.railsrumble.com", :primary => true

set :deploy_to, "/home/magpie/#{application}"
set :scm, :git
set :branch, "master"
set :user, "magpie"

after "deploy:finalize_update", "db:setup"

namespace :deploy do
   desc "restart passenger"
   task :restart, :roles => :app, :except => {:no_release => true} do
      run "touch #{current_path}/tmp/restart.txt"
   end

   [:start, :stop].each do |t|
      desc "#{t} task is a no-op with passenger"
      task t, :roles => :app do ; end
   end
end 

namespace :db do
  task :setup, :except => {:no_release => true} do 
    default_template = <<-EOF
      production:
        adapter: mysql
        encoding: utf8
        database: magpie
        pool: 5
        username: magpie
        password: magpie
        socket: /var/run/mysqld/mysqld.sock
    EOF

    config = ERB.new(default_template)
    put config.result(binding), "#{shared_path}/database.yml"
    run "ln -nfs #{shared_path}/database.yml #{release_path}/config/database.yml"
  end
end
