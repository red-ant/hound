lock '3.1.0'
set :application, 'milo'
set :repo_url, 'https://github.com/red-ant/hound.git'

set :deploy_to, "/home/deploy/apps/#{fetch(:application)}"
set :scm, :git
set :format, :pretty
set :log_level, :debug
set :linked_files, %w{.env config/database.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}
set :keep_releases, 5
set :rvm_ruby_string, `rvm current`.chomp!
namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo god restart #{fetch(:application)}_unicorn"
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end
