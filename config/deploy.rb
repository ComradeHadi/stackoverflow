lock '3.4.0'

set :application, 'stackoverflow'
set :repo_url, 'git@github.com:anatoly-cmdx/stackoverflow.git'
set :deploy_to, '/home/deploy/stackoverflow'
set :deploy_user, 'deploy'

set :linked_files, fetch(:linked_files, []).push(
  'config/database.yml',
  'config/secrets.yml',
  'config/private_pub.yml'
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
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end
