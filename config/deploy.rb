lock '3.4.0'

set :application, 'stackoverflow'
set :repo_url, 'git@github.com:anatoly-cmdx/stackoverflow.git'
set :deploy_to, '/home/deploy/stackoverflow'
set :deploy_user, 'deploy'

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/secrets.yml',
  'config/private_pub.yml',
  'config/private_pub_thin.yml'
)

set :linked_dirs, fetch(:linked_dirs, []).push(
  'log',
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'public/system',
  'public/uploads'
)

namespace :deploy do
 # after :publishing :restart -- will automatically

 # You can also run the underlying task in isolation:
 # Restart your Passenger application.
 # The restart mechanism used is based on the version of Passenger installed on your server.
 # $ cap production passenger:restart
 # Alternatively:
 # $ cap production deploy:restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end

namespace :private_pub do
  set :private_pub_pid, -> { "#{current_path}/tmp/pids/private_pub.pid" }

  desc 'start private_pub server'
  task :start do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:stage) do
          execute :bundle, \
            "exec thin -C config/private_pub_thin.yml -P #{fetch(:private_pub_pid)} start"
        end
      end
    end
  end

  desc 'stop private_pub server'
  task :stop do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:stage) do
          execute "if [ -f #{fetch(:private_pub_pid)} ] && [ -e /proc/$(cat #{fetch(:private_pub_pid)}) ]; then kill -9 `cat #{fetch(:private_pub_pid)}`; fi"
        end
      end
    end
  end

  desc 'restart private_pub server'
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:stage) do
          invoke 'private_pub:stop'
          invoke 'private_pub:start'
        end
      end
    end
  end
end

after 'deploy:restart', 'private_pub:restart'
