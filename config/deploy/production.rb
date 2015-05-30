set :rails_env, :production
set :stage, :production

server '178.62.218.37',
  user: 'deploy',
  roles: %w(app db web),
  primary: true,
  ssh_options: {
    keys: %w(/home/deploy/.ssh/id_rsa),
    forward_agent: true,
    auth_methods: %w(publickey),
    port: 4322
  }
